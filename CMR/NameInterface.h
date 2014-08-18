//
//  NameInterface.h
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"
@protocol NameInterfaceDelegate;
@interface NameInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <NameInterfaceDelegate> delegate;

-(void)getNameInterfaceDelegateWithID:(NSString *)str andName:(NSString *)name andType:(NSString *)type;
@end

@protocol NameInterfaceDelegate <NSObject>

-(void)getNameInfoDidFinished:(NSDictionary *)result;
-(void)getNameInfoDidFailed:(NSString *)errorMsg;

@end
