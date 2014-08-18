//
//  ContactAndRecentInterface.h
//  CMR
//
//  Created by comdosoft on 14-1-23.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"
@protocol ContactAndRecentInterfaceDelegate;
@interface ContactAndRecentInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <ContactAndRecentInterfaceDelegate> delegate;

-(void)getContactAndRecentInterfaceDelegateWithType:(NSString *)type;
@end

@protocol ContactAndRecentInterfaceDelegate <NSObject>

-(void)getListInfoDidFinished:(NSDictionary *)result;
-(void)getListInfoDidFailed:(NSString *)errorMsg;

@end

