//
//  ShaixuanViewController.h
//  CMR
//
//  Created by comdosoft on 14-2-20.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShaixuanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end
