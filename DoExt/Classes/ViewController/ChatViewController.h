//
//  ChatViewController.h
//  HuanxinDemo
//
//  Created by yz on 15/4/4.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (void)reloadData;

@end
