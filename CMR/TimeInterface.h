//
//  TimeInterface.h
//  CMR
//
//  Created by comdosoft on 14-2-19.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "BaseInterface.h"
@protocol TimeInterfaceDelegate;
@interface TimeInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <TimeInterfaceDelegate> delegate;

-(void)getTimeInterfaceDelegateWithStart:(NSString *)start andEnd:(NSString *)end andType:(NSString *)type;
@end

@protocol TimeInterfaceDelegate <NSObject>
-(void)getTimeInfoDidFinished;
-(void)getTimeInfoDidFailed:(NSString *)errorMsg;

@end
