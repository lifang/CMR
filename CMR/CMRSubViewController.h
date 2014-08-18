//
//  CMRSubViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-13.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactObject.h"
#import "CMRSubButton.h"

@class CMRContactViewController;

@interface CMRSubViewController : UIViewController
@property (nonatomic, strong) CMRContactViewController *contactView;

@property (nonatomic, strong) ContactObject *person;
@property (nonatomic, strong) NSIndexPath *idxPath;
@end
