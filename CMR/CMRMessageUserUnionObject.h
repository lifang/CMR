//
//  CMRMessageUserUnionObject.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMRMessageObject.h"
#import "ContactObject.h"

@interface CMRMessageUserUnionObject : NSObject
@property (nonatomic,strong) CMRMessageObject* message;
@property (nonatomic,strong) ContactObject* user;

+(CMRMessageUserUnionObject *)unionWithMessage:(CMRMessageObject *)aMessage andUser:(ContactObject *)aUser;
@end
