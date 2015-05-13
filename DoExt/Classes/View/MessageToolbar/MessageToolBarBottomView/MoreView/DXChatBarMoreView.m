/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 60
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame typw:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    NSString *filePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"HuanXinIM_SM.bundle/Resources/ChatView"];
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 3 * CHAT_BUTTON_SIZE) / 4;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    NSString *filePhotoName = [filePath stringByAppendingPathComponent:@"chatBar_colorMore_photo@2x.png"];
    NSString *filePhotoSelName = [filePath stringByAppendingPathComponent:@"chatBar_colorMore_photoSelected@2x.png"];
    [_photoButton setImage:[UIImage imageWithContentsOfFile:filePhotoName] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageWithContentsOfFile:filePhotoSelName] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
//    NSString *fileLocationName = [filePath stringByAppendingPathComponent:@"chatBar_colorMore_location@2x.png"];
//    NSString *fileLocationSelName = [filePath stringByAppendingPathComponent:@"chatBar_colorMore_locationSelected@2x.png"];
//    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_locationButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_locationButton setImage:[UIImage imageWithContentsOfFile:fileLocationName] forState:UIControlStateNormal];
//    [_locationButton setImage:[UIImage imageWithContentsOfFile:fileLocationSelName] forState:UIControlStateHighlighted];
//    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_locationButton];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE * 1, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    NSString *fileCameraName = [filePath stringByAppendingPathComponent:@"chatBar_colorMore_camera@2x.png"];
    NSString *fileCameraSelName = [filePath stringByAppendingPathComponent:@"chatBar_colorMore_cameraSelected@2x.png"];
    
    [_takePicButton setImage:[UIImage imageWithContentsOfFile:fileCameraName] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageWithContentsOfFile:fileCameraSelName] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
    NSString *fileVideoName = [filePath stringByAppendingPathComponent:@"chatBar_colorMore_video@2x.png"];
    NSString *fileVideoSelName = [filePath stringByAppendingPathComponent:@"chatBar_colorMore_videoSelected@2x.png"];
    _videoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_videoButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_videoButton setImage:[UIImage imageWithContentsOfFile:fileVideoName] forState:UIControlStateNormal];
    [_videoButton setImage:[UIImage imageNamed:fileVideoSelName] forState:UIControlStateHighlighted];
    [_videoButton addTarget:self action:@selector(takeVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_videoButton];
    
    CGRect frame = self.frame;
    if (type == ChatMoreTypeChat) {
        //        frame.size.height = 150;
        //
        //        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        //        [_audioCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        //        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
        //        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
        //        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:_audioCallButton];
    }
    else if (type == ChatMoreTypeGroupChat)
    {
        frame.size.height = 80;
    }
    self.frame = frame;
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeVideoAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewVideoAction:self];
    }
}

- (void)takeAudioCallAction
{
    //    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
    //        [_delegate moreViewAudioCallAction:self];
    //    }
}

@end
