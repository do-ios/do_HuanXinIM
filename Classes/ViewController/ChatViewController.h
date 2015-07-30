//
//  ChatViewController.h
//  HuanxinDemo
//
//  Created by yz on 15/4/4.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property(nonatomic,copy) NSString *userNickname;
@property(nonatomic,copy) NSString *selfNick;
@property(nonatomic,copy) NSString *userIconUrl;
@property(nonatomic,copy) NSString *myIconUrl;
@property(nonatomic,copy) NSString *tag;
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (void)reloadData;

@end
