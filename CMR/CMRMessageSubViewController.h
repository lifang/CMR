//
//  CMRMessageSubViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-15.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMRMessageObject.h"
#import "CMRSubButton.h"

@class CMRSendMessageViewController;

@interface CMRMessageSubViewController : UIViewController

@property (nonatomic, strong) CMRSendMessageViewController *sendMessageView;
@property (nonatomic, strong) CMRMessageObject *aMessage;
@property (nonatomic, strong) NSIndexPath *aIndex;
@end
