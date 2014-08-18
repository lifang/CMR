//
//  ContactObject.m
//  CMR
//
//  Created by comdosoft on 14-1-10.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "ContactObject.h"
#import "CMRDataBase.h"

@implementation ContactObject

+(ContactObject *)userFromDictionary:(NSDictionary *)aDic {
    ContactObject *contact = [[ContactObject alloc]init];
    [contact setLocalID:[NSNumber numberWithInt:[[aDic objectForKey:kUSER_LOCALID]intValue]]];
    [contact setName:[aDic objectForKey:kUSER_NAME]];
    [contact setUserHead:[aDic objectForKey:kUSER_USERHEAD]];
    NSArray *p_array = [[NSArray alloc]initWithObjects:[aDic objectForKey:kUSER_PHONE], nil];
    [contact setPhoneArray:[NSMutableArray arrayWithArray:p_array]];
    [contact setIsMakeRemind:[[aDic objectForKey:kUSER_REMIND]intValue]];
    [contact setIsNewMessage:[[aDic objectForKey:kUSER_MESSAGE]intValue]];
    if ([aDic objectForKey:kUSER_CONTENT]) {
        [contact setHtml_content:[aDic objectForKey:kUSER_CONTENT]];
    }
    [contact setRemark:[aDic objectForKey:kUSER_REMARK]];
    [contact setIsShield:[[aDic objectForKey:kUSER_SHIELD]intValue]];
    [contact setTags:[NSMutableArray arrayWithArray:[aDic objectForKey:kUSER_TAGS]]];
    return contact;
}

@end
