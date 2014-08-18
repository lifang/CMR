//
//  MessageInterface.h
//  CMR
//
//  Created by comdosoft on 14-1-22.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"
@protocol MessageInterfaceDelegate;

@interface MessageInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <MessageInterfaceDelegate> delegate;

-(void)getMessageInterfaceDelegateWithID:(NSString *)str andPage:(NSString *)page;
@end

@protocol MessageInterfaceDelegate <NSObject>

-(void)getMessageInfoDidFinished:(NSDictionary *)result;
-(void)getMessageInfoDidFailed:(NSString *)errorMsg;

@end

