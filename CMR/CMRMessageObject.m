//
//  CMRMessageObject.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRMessageObject.h"
#import "CMRDataBase.h"

@implementation CMRMessageObject

+(CMRMessageObject*)messageFromDictionary:(NSDictionary*)aDic
{
    CMRMessageObject *msg=[[CMRMessageObject alloc]init];
    [msg setMessageId:[NSNumber numberWithInt:[[aDic objectForKey:kMESSAGE_ID]intValue]]];
    [msg setMessageFrom:[NSString stringWithFormat:@"%@",[aDic objectForKey:kMESSAGE_FROM]]];
    [msg setMessageTo:[NSString stringWithFormat:@"%@",[aDic objectForKey:kMESSAGE_TO]]];
    [msg setMessageContent:[NSString stringWithFormat:@"%@",[aDic objectForKey:kMESSAGE_CONTENT]]];
    [msg setMessageDate:[NSString stringWithFormat:@"%@",[aDic objectForKey:kMESSAGE_DATE]]];
    [msg setMessageType:[NSNumber numberWithInt:[[aDic objectForKey:kMESSAGE_TYPE]intValue]]];
    if (![[aDic objectForKey:kMEDIA_TYPE]isKindOfClass:[NSNull class]]) {
        [msg setMediaType:[NSNumber numberWithInt:[[aDic objectForKey:kMEDIA_TYPE]intValue]]];
    }
    if (![[aDic objectForKey:KMESSAGE_PATH]isKindOfClass:[NSNull class]]) {
        [msg setPath:[NSString stringWithFormat:@"%@",[aDic objectForKey:KMESSAGE_PATH]]];
    }
    
    if (![[aDic objectForKey:kMESSAGE_STATUS]isKindOfClass:[NSNull class]]) {
        [msg setMessageStatus:[NSString stringWithFormat:@"%@",[aDic objectForKey:kMESSAGE_STATUS]]];
    }
    
    return  msg;
}

@end
