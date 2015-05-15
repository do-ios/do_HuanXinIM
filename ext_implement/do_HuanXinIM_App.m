//
//  M0005_HuanXinIM_App.m
//  DoExt_SM
//
//  Created by 刘吟 on 15/4/9.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_HuanXinIM_App.h"
#import "EaseMob.h"
#import "doServiceContainer.h"
#import "doIModuleExtManage.h"

@implementation do_HuanXinIM_App
@synthesize ThridPartyID;
//- (instancetype)init
//{
//    if (self = [super init]) {
//        self.ThridPartyID = @"HuanXin";
//    }
//    return self;
//}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     NSString *huanxinKey = [[doServiceContainer Instance].ModuleExtManage GetThirdAppKey:@"do_HuanXinIM.plist" :@"EASEMOB_APPKEY"];
    [[EaseMob sharedInstance] registerSDKWithAppKey:huanxinKey apnsCertName:nil];

    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation fromThridParty:(NSString *)_id
{
    return  [[EaseMob sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url fromThridParty:(NSString *)_id
{
    return [[EaseMob sharedInstance] application:application handleOpenURL:url];
}
@end
