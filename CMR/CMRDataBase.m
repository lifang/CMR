//
//  CMRDataBase.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRDataBase.h"

@implementation CMRDataBase
static CMRDataBase *defaultCMRDataBase = nil;
+(CMRDataBase *)defaultSection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCMRDataBase = [[CMRDataBase alloc] init];
    });
    return defaultCMRDataBase;
}
//消息
-(BOOL)addData:(CMRMessageObject *)aMessage {
    BOOL res = [self.db executeUpdate:@"INSERT INTO 'cmrMessage' ('messageFrom','messageTo','messageContent','messageDate','messageType') VALUES (?,?,?,?,?)"
                ,aMessage.messageFrom
                ,aMessage.messageTo
                ,aMessage.messageContent
                ,aMessage.messageDate
                ,aMessage.messageType];
    return res;
}


@end
