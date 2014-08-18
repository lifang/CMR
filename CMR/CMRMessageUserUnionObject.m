//
//  CMRMessageUserUnionObject.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRMessageUserUnionObject.h"

@implementation CMRMessageUserUnionObject

+(CMRMessageUserUnionObject *)unionWithMessage:(CMRMessageObject *)aMessage andUser:(ContactObject *)aUser {
    CMRMessageUserUnionObject *unionObject=[[CMRMessageUserUnionObject alloc]init];
    [unionObject setUser:aUser];
    [unionObject setMessage:aMessage];
    return unionObject;
}
@end
