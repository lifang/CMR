//
//  ContactObject.h
//  CMR
//
//  Created by comdosoft on 14-1-10.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUSER_LOCALID @"id"
#define kUSER_NAME @"name"
#define kUSER_PHONE @"mobiephone"
#define kUSER_CONTENT @"html_content"
#define kUSER_USERHEAD @"avatar_url"
#define kUSER_MESSAGE @"has_new_message"
#define kUSER_REMIND @"has_new_record"
#define kUSER_REMARK @"remark"
#define kUSER_SHIELD @"status"
#define kUSER_TAGS @"tags"
@interface ContactObject : NSObject

@property (nonatomic, strong) NSNumber *localID;
@property (nonatomic, strong) NSString *name;       //姓名
@property (nonatomic, strong) NSMutableArray *phoneArray;
@property (nonatomic, strong) NSString* userHead;   //头像

@property (nonatomic, strong) NSString *html_content;

@property (nonatomic, assign) NSInteger isNewMessage;//0:无    1:有新消息
@property (nonatomic, assign) NSInteger isMakeRemind;//0:无    1:保存提醒

@property (nonatomic, strong) NSString *remark;//备注
@property (nonatomic, assign) NSInteger isShield;//0:无    1:屏蔽消息

@property (nonatomic, strong) NSMutableArray *tags;//标签
+(ContactObject *)userFromDictionary:(NSDictionary *)aDic;
@end
