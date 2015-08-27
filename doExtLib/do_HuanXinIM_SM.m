//
//  M0005_HuanXinIM_SM.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_HuanXinIM_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doJsonHelper.h"
#import "EaseMob.h"
#import "doIPage.h"
#import "ChatViewController.h"
#import "IEMMessageBody.h"


@interface do_HuanXinIM_SM ()<EMChatManagerDelegate>
@property(nonatomic,strong) id<doIScriptEngine> scritEngine;
@property(nonatomic,copy) NSString *callbackName;
@end

@implementation do_HuanXinIM_SM
#pragma mark -
#pragma mark - 同步异步方法的实现
/*
 1.参数节点
 doJsonNode *_dictParas = [parms objectAtIndex:0];
 a.在节点中，获取对应的参数
 NSString *title = [_dictParas GetOneText:@"title" :@"" ];
 说明：第一个参数为对象名，第二为默认值
 
 2.脚本运行时的引擎
 id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
 
 同步：
 3.同步回调对象(有回调需要添加如下代码)
 doInvokeResult *_invokeResult = [parms objectAtIndex:2];
 回调信息
 如：（回调一个字符串信息）
 [_invokeResult SetResultText:((doUIModule *)_model).UniqueKey];
 异步：
 3.获取回调函数名(异步方法都有回调)
 NSString *_callbackName = [parms objectAtIndex:2];
 在合适的地方进行下面的代码，完成回调
 新建一个回调对象
 doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
 填入对应的信息
 如：（回调一个字符串）
 [_invokeResult SetResultText: @"异步方法完成"];
 [_scritEngine Callback:_callbackName :_invokeResult];
 */
//同步
- (void)enterChat:(NSArray *)parms
{
    doInvokeResult *statusResult = [[doInvokeResult alloc]init];
    [statusResult SetResultInteger:1];
    [self.EventCenter FireEvent:@"chatStatusChanged" :statusResult];
    //自己的代码实现
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //js引擎
    self.scritEngine = [parms objectAtIndex:1];
    
    //自己的代码实现
    NSString *userID = [doJsonHelper GetOneText:_dictParas :@"userID" :@""];
    NSString *userNick = [doJsonHelper GetOneText:_dictParas :@"userNick" :@""];
    NSString *userIcon = [doJsonHelper GetOneText:_dictParas :@"userIcon" :@""];
    NSString *selfNick = [doJsonHelper GetOneText:_dictParas :@"selfNick" :@""];
    NSString *selfIcon = [doJsonHelper GetOneText:_dictParas :@"selfIcon" :@""];
    NSString *tag = [doJsonHelper GetOneText:_dictParas :@"tag" :@""];
        //通过用户名得到聊天会话对象
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:userID isGroup:NO];
    [UIApplication sharedApplication].applicationIconBadgeNumber -= [conversation unreadMessagesCount];
    [conversation markAllMessagesAsRead:YES];
    NSString *chatter = conversation.chatter;
    //初始化聊天控制器
    ChatViewController *chatVC = [[ChatViewController alloc]initWithChatter:chatter isGroup:NO];
    chatVC.userNickname = userNick;
    if (userIcon != nil && userIcon.length > 0) {
        chatVC.userIconUrl = userIcon;
    }
    if (selfIcon != nil && selfIcon.length > 0) {
        chatVC.myIconUrl = selfIcon;
    }
    chatVC.selfNick = selfNick;
    chatVC.tag = tag;
    id<doIPage>pageModel = _scritEngine.CurrentPage;
    UIViewController *currentVC = (UIViewController *)pageModel.PageView;
    [currentVC presentViewController:chatVC animated:YES completion:^{
        
    }];
}
- (void)logout:(NSArray *)parms
{
    //自己的代码实现
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
    } onQueue:nil];
}
//异步
- (void)login:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //自己的代码实现
    self.scritEngine = [parms objectAtIndex:1];
    self.callbackName = [parms objectAtIndex:2];
    NSString * userName = [doJsonHelper GetOneText:_dictParas :@"username" :@""];
    NSString * userPwd = [doJsonHelper GetOneText:_dictParas :@"password" :@""];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:userPwd];
}

-(void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    EMError *err = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
    if (!err) {
       [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    }
    NSMutableDictionary *infoNode = [[NSMutableDictionary alloc]init];
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init:self.UniqueKey];
    if (!error && loginInfo)
    {
        [infoNode setValue:@"0" forKey:@"state"];
        [infoNode setValue:@"success" forKey:@"message"];
    }
    else
    {
        [infoNode setValue:@"1" forKey:@"state"];
        [infoNode setValue:error.description forKey:@"message"];
    }
    [_invokeResult SetResultNode:infoNode];
    [self.scritEngine Callback:self.callbackName :_invokeResult];
}

- (void)didReceiveMessage:(EMMessage *)message
{
    [self notificationLocal:message];
    id<IEMMessageBody> messageBody = [message.messageBodies lastObject];
    NSString *messageForm = message.from;
    NSString *userNick = [message.ext valueForKey:@"nick"];
    NSString *selfIcon = [message.ext valueForKey:@"icon"];
    NSString *tag = [message.ext valueForKey:@"tag"];
    NSString *desc = [message description];
    NSData *JSONData = [desc dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *messageBodies = [responseJSON valueForKey:@"bodies"];
    NSString *messageFirstBody = [messageBodies firstObject];
    JSONData = [messageFirstBody dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageBodyDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    NSString *messageBodyStr = [messageBodyDict valueForKey: @"msg"];
    if (messageBody.messageBodyType == eMessageBodyType_Image) {
        messageBodyStr = @"图片";
    }
    else if(messageBody.messageBodyType == eMessageBodyType_Voice)
    {
        messageBodyStr = @"音频";
    }
    NSString *messageType = [messageBodyDict valueForKey:@"type"];
    messageType = [self changeType:messageType];
    NSString *messageTime = [NSString stringWithFormat:@"%lld",message.timestamp];
    doInvokeResult *_result = [[doInvokeResult alloc]init:self.UniqueKey];
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setValue:messageForm forKey:@"from"];
    [resultDict setValue:tag forKey:@"tag"];
    [resultDict setValue:userNick forKey:@"nick"];
    [resultDict setValue:selfIcon forKey:@"icon"];
    [resultDict setValue:messageType forKey:@"type"];
    [resultDict setValue:messageBodyStr forKey:@"message"];
    [resultDict setValue:messageTime forKey:@"time"];
    [_result SetResultNode:resultDict];
    [self.EventCenter FireEvent:@"receive" :_result];
}
- (void)notificationLocal:(EMMessage *)message
{
    BOOL needShowNotification = message.isGroup ? [self needShowNotification:message.conversationChatter] : YES;
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }
//        }else {
//            [self playSoundAndVibration];
//        }
#endif
    }
}
- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"图片";
            }
                break;
            
            case eMessageBodyType_Voice:
            {
                messageStr = @"语音";
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.isGroup) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"你有一条新消息";
    }
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSString *)changeType:(NSString *)type
{
    NSString *tempType;
    if ([type isEqualToString:@"txt"]) {
        tempType = @"TXT";
    }
    else if ([type isEqualToString:@"img"])
    {
        tempType = @"IMAGE";
    }
    else if ([type isEqualToString:@"audio"])
    {
        tempType = @"VOICE";
    }
    return tempType;
}
/**
 *  离线消息回调
 *
 *  @param offlineMessages <#offlineMessages description#>
 */
-(void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        NSString *messageForm = message.from;
        NSString *userNick = [message.ext valueForKey:@"nick"];
        NSString *selfIcon = [message.ext valueForKey:@"icon"];
        NSString *tag = [message.ext valueForKey:@"tag"];
        NSString *desc = [message description];
        NSData *JSONData = [desc dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        NSArray *messageBodies = [responseJSON valueForKey:@"bodies"];
        NSString *messageFirstBody = [messageBodies firstObject];
        JSONData = [messageFirstBody dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *messageBodyDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        NSString *messageBody = [messageBodyDict valueForKey: @"msg"];
        NSString *messageType = [messageBodyDict valueForKey:@"type"];
        messageType = [self changeType:messageType];
        NSString *messageTime = [NSString stringWithFormat:@"%lld",message.timestamp];
        doInvokeResult *_result = [[doInvokeResult alloc]init:self.UniqueKey];
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        [resultDict setValue:messageForm forKey:@"from"];
        [resultDict setValue:tag forKey:@"tag"];
        [resultDict setValue:userNick forKey:@"nick"];
        [resultDict setValue:selfIcon forKey:@"icon"];
        [resultDict setValue:messageType forKey:@"type"];
        [resultDict setValue:messageBody forKey:@"message"];
        [resultDict setValue:messageTime forKey:@"time"];
        [_result SetResultNode:resultDict];
        [self.EventCenter FireEvent:@"receive" :_result];
    }
}

- (void)didLoginFromOtherDevice
{
    doInvokeResult *_result = [[doInvokeResult alloc]init:self.UniqueKey];
    NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
    [resDict setObject:@"2" forKey:@"state"];
    [_result SetResultNode:resDict];//2 显示帐号在其他设备登陆
    [self.EventCenter FireEvent:@"connection" :_result];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
    } onQueue:nil];}

- (void)didRemovedFromServer
{
    doInvokeResult *_result = [[doInvokeResult alloc]init:self.UniqueKey];
    NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
    [resDict setObject:@"1" forKey:@"state"];
    [_result SetResultNode:resDict];//1 显示帐号已经被移除
    [self.EventCenter FireEvent:@"connection" :_result];
}
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        doInvokeResult *_result = [[doInvokeResult alloc]init:self.UniqueKey];
        NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
        [resDict setObject:@"4" forKey:@"state"];
        [_result SetResultNode:resDict];//4 当前网络不可用 请检查网络设置
        [self.EventCenter FireEvent:@"connection" :_result];
    }
}
-(void)didAutoReconnectFinishedWithError:(NSError *)error
{
    
}

@end









