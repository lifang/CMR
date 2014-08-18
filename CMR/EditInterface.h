//
//  EditInterface.h
//  CMR
//
//  Created by comdosoft on 14-1-23.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"
@protocol EditInterfaceDelegate;
@interface EditInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <EditInterfaceDelegate> delegate;

-(void)getEditInterfaceDelegateWithMessageId:(NSString *)messageId andContent:(NSString *)content andType:(int)type;
@end

@protocol EditInterfaceDelegate <NSObject>

-(void)getEditInfoDidFinished:(NSDictionary *)result;
-(void)getEditInfoDidFailed:(NSString *)errorMsg;

@end
