//
//  SendMessageInterface.h
//  CMR
//
//  Created by comdosoft on 14-1-25.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"
@protocol SendMessageInterfaceDelegate;
@interface SendMessageInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <SendMessageInterfaceDelegate> delegate;

-(void)getSendMessageInterfaceDelegateWithTo_userId:(NSString *)toId andContent:(NSString *)content andType:(NSString *)type;
@end

@protocol SendMessageInterfaceDelegate <NSObject>

-(void)getSendMessageInfoDidFinished:(NSDictionary *)result;
-(void)getSendMessageInfoDidFailed:(NSString *)errorMsg;

@end
