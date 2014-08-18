//
//  SelectTimeViewController.h
//  CMR
//
//  Created by comdosoft on 14-2-19.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeInterface.h"
@interface SelectTimeViewController : UIViewController<TimeInterfaceDelegate>

@property (nonatomic, strong) TimeInterface *timeInter;
@property (nonatomic, strong) IBOutlet UIView *timeView;
@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) UIBarButtonItem *sureBtn;


@property (nonatomic, strong) IBOutlet UITextField *startTxt;
@property (nonatomic, strong) IBOutlet UITextField *endTxt;
@property (nonatomic, strong) IBOutlet UISwitch *switchBtn;
@property (nonatomic, assign) NSInteger tag_first;
@end
