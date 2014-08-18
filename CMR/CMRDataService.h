//
//  CMRDataService.h
//  CMR
//
//  Created by comdosoft on 14-1-16.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRDataService : NSObject
{
    BOOL _free;
    BOOL _holding;
}
@property (nonatomic, strong) NSString *host;
//登录人
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *site_id;
@property (nonatomic, strong) NSString *user_head;

@property (nonatomic, strong) NSMutableArray *contactList;
@property (nonatomic, strong) NSMutableArray *temp_contact;
@property (nonatomic, strong) NSMutableArray *messageList;

@property (nonatomic, strong) NSString *recordModel;//记录模版
@property (nonatomic, strong) NSString *remindModel;//提醒模版

//处于聊天界面－－－－－正在与这个人聊天
@property (nonatomic, assign) NSInteger chat_person_id;
@property (nonatomic, assign) BOOL isChating;
//筛选条件
@property (nonatomic, strong) NSMutableArray *tag_array;
@property (nonatomic, strong) NSString *seleted_str;
//通知免打扰模式
@property (nonatomic, assign) NSInteger flag;//判断是否打开0:无  1:打开
@property (nonatomic, strong) NSString *strat_time;
@property (nonatomic, strong) NSString *end_time;
+ (CMRDataService *)shared;
//区分订阅号还是服务号
@property (nonatomic, assign) NSInteger jurisdiction;//0订阅号     1服务号
@property (nonatomic, assign) NSInteger headSize;
@property (nonatomic, assign) BOOL isEditing;//判断是否编辑信息了
//控制键盘
@property (nonatomic, assign) NSInteger keyBoardTag;


//编辑之后刷新
@property (nonatomic, assign) NSInteger index_row;
/** hold the thread when background task will terminate */
- (void)hold;

/** free from holding when applicaiton become active */
- (void)stop;

/** running in background, call this funciton when application become background */
- (void)run;
@end
