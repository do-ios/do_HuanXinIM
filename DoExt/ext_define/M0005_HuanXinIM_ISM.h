//
//  M0005_HuanXinIM_IMethod.h
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol M0005_HuanXinIM_ISM <NSObject>

@required
//实现同步或异步方法，parms中包含了所需用的属性
- (void)enterChat:(NSArray *)parms;
- (void)login:(NSArray *)parms;
- (void)logout:(NSArray *)parms;

@end