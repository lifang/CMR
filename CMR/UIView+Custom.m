//
//  UIView+Custom.m
//  CMR
//
//  Created by comdosoft on 14-1-28.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "UIView+Custom.h"

@implementation UIView (Custom)
-(void)viewReadyToShow {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewDidAppear" object:nil];
}
@end
