//
//  DeleteInterface.h
//  CMR
//
//  Created by comdosoft on 14-1-23.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"
@protocol DeleteInterfaceDelegate;
@interface DeleteInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <DeleteInterfaceDelegate> delegate;

-(void)getDeleteInterfaceDelegateWithID:(NSString *)str;
@end

@protocol DeleteInterfaceDelegate <NSObject>

-(void)getDeleteInfoDidFinished:(NSDictionary *)result;
-(void)getDeleteInfoDidFailed:(NSString *)errorMsg;

@end
