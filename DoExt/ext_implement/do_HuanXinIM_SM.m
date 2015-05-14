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
    //自己的代码实现
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //js引擎
    self.scritEngine = [parms objectAtIndex:1];
    
    //自己的代码实现
    
    NSString *userName = [doJsonHelper GetOneText:_dictParas :@"username" :@""];
    NSString *userNickname = [doJsonHelper GetOneText:_dictParas :@"userNickname" :@""];
    NSString *userIcon = [doJsonHelper GetOneText:_dictParas :@"userIcon" :@""];
    NSString *myIcon = [doJsonHelper GetOneText:_dictParas :@"myIcon" :@""];
    //通过用户名得到聊天会话对象
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:userName isGroup:NO];
    NSString *chatter = conversation.chatter;
    //初始化聊天控制器
    ChatViewController *chatVC = [[ChatViewController alloc]initWithChatter:chatter isGroup:NO];
    chatVC.userNickname = userNickname;
    if (userIcon != nil && userIcon.length > 0) {
        chatVC.userIconUrl = userIcon;
    }
    if (myIcon != nil && myIcon.length > 0) {
        chatVC.myIconUrl = myIcon;
    }
    id<doIPage>pageModel = _scritEngine.CurrentPage;
    UIViewController *currentVC = (UIViewController *)pageModel.PageView;
    [currentVC presentViewController:chatVC animated:YES completion:^{
        
    }];
}
- (void)logout:(NSArray *)parms
{
    //自己的代码实现
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
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
    NSMutableDictionary *infoNode = [[NSMutableDictionary alloc]init];
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init:nil];
    if (!error && loginInfo)
    {
        [infoNode setValue:@"0" forKey:@"state"];
    }
    else
    {
        [infoNode setValue:@"0" forKey:@"state"];
        [infoNode setValue:error.description forKey:@"message"];
    }
    [_invokeResult SetResultNode:infoNode];
    [self.scritEngine Callback:self.callbackName :_invokeResult];
}

@end









