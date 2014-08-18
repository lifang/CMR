//
//  SettingViewViewController.h
//  CMR
//
//  Created by comdosoft on 14-2-14.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetSecondCell.h"
#import "SetCellFooter.h"

@interface SettingViewViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTable;
@end
