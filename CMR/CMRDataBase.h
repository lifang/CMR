//
//  CMRDataBase.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRBaseDao.h"
#import "CMRMessageObject.h"
//#import "CMRUserObject.h"
#import "CMRMessageUserUnionObject.h"
#import "ContactObject.h"
@interface CMRDataBase : CMRBaseDao
+(CMRDataBase *)defaultSection;
//消息
-(BOOL)addData:(CMRMessageObject *)aMessage;


@end
