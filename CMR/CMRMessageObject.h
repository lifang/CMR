//
//  CMRMessageObject.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KMESSAGE_PATH @"message_path"
#define kMEDIA_TYPE @"message_type" //消息类型
#define kMESSAGE_TYPE @"types" //消息类型
#define kMESSAGE_FROM @"from_user" //接受
#define kMESSAGE_TO @"to_user"     //发送
#define kMESSAGE_CONTENT @"content"  //消息内容
#define kMESSAGE_DATE @"date"  //消息时间
#define kMESSAGE_ID @"id"      //消息id
#define kMESSAGE_STATUS @"status"

//定义消息类型
enum CMRMessageType {
    CMRMessageTypePhone = 0,  //打电话
    CMRMessageTypeSms = 1,    //发短信
    CMRMessageTypeNote = 2,   //做记录
    CMRMessageTypeRemind=3,    //提醒
    CMRMessageTypeWeixin=4    //微信
};

enum CMRmediaType {
    CMRmediaTypeText = 0,//文字
    CMRmediaTypeImage = 1,//图片
    CMRmediaTypeVoice = 2 //语音
};
//定义消息cell的类型
enum CMRMessageCellStyle {
    CMRMessageCellStyleMe = 0,
    CMRMessageCellStyleOther = 1,
};

@interface CMRMessageObject : NSObject

@property (nonatomic, strong) NSString *messageFrom;
@property (nonatomic, strong) NSString *messageTo;
@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, strong) NSString *messageDate;
@property (nonatomic, strong) NSNumber *messageType;
@property (nonatomic, strong) NSNumber *mediaType;
@property (nonatomic, strong) NSNumber *messageId;
@property (nonatomic, strong) NSString *messageStatus;
@property (nonatomic, strong) NSString *path;

+(CMRMessageObject *)messageFromDictionary:(NSDictionary*)aDic;


@end
