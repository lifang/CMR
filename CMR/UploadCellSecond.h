//
//  UploadCellSecond.h
//  ZQApp
//
//  Created by peng on 14-2-13.
//  Copyright (c) 2014年 QCX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondDelegate <NSObject>
-(void)setShieldBy:(UISwitch *)aSwitch;
@end
@interface UploadCellSecond : UITableViewCell
@property (nonatomic, assign) id<SecondDelegate>delegate;
@property (nonatomic, strong) UISwitch *switchBtn;

@end
