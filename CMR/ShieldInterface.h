//
//  ShieldInterface.h
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"
@protocol ShieldInterfaceDelegate;
@interface ShieldInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <ShieldInterfaceDelegate> delegate;

-(void)getShieldInterfaceDelegateWithID:(NSString *)str andType:(NSString *)type;
@end

@protocol ShieldInterfaceDelegate <NSObject>
-(void)getShieldInfoDidFinished:(NSDictionary *)result;
-(void)getShieldInfoDidFailed:(NSString *)errorMsg;

@end
