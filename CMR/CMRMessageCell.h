//
//  CMRMessageCell.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMRMessageObject.h"

//头像大小
//#define HEAD_SIZE 40.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 4.0f
#import "CMRSubButton.h"

@protocol MessageDelegate <NSObject>
-(void)playVoiceWith:(CMRSubButton *)btn;
@end
@interface CMRMessageCell : UITableViewCell {
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;
    UIImageView *_chatImage;
    UILabel *_messageConent;
    UILabel *_timeLab;
    //提醒
    UILabel *_titleLab;
//    UILabel *_detailLab;
    int _messageType;
    int _mediaType;
}
@property (nonatomic, assign) id<MessageDelegate>delegate;
@property (nonatomic, strong) CMRSubButton *voiceBtn;
@property (nonatomic, strong) UIImageView *messageTypeImg;
@property (nonatomic, assign) enum CMRMessageCellStyle msgStyle;
@property (nonatomic, assign) int height;
@property (nonatomic, strong) NSString *content;

-(void)setMessageObject:(CMRMessageObject *)aMessage;
-(void)setHeadImage:(NSString *)head;
-(void)setChatImage:(UIImage *)chatImage;
-(void)getImageWithStr:(NSString *)str;
@end
