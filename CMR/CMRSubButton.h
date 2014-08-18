//
//  CMRSubButton.h
//  CMR
//
//  Created by comdosoft on 14-1-14.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactObject.h"
#import "CMRMessageObject.h"
@interface CMRSubButton : UIButton
@property (nonatomic, strong) ContactObject *person;
@property (nonatomic, strong) CMRMessageObject *msg;
@property (nonatomic, strong) NSIndexPath *index;

@end
