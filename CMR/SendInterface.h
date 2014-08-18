//
//  SendInterface.h
//  CMR
//
//  Created by comdosoft on 14-2-21.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"

@protocol SendInterfaceeDelegate;
@interface SendInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <SendInterfaceeDelegate> delegate;

-(void)getSendInterfaceDelegateWithContent:(NSString *)content andType:(NSString *)type andId:(NSString *)Id;
@end

@protocol SendInterfaceeDelegate <NSObject>
-(void)getSendInfoDidFinished:(NSDictionary *)result;
-(void)getSendInfoDidFailed:(NSString *)errorMsg;

@end

