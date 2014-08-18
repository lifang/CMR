//
//  CMRMoreViewController.h
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactObject.h"
#import "UploadCellFirst.h"
#import "UploadCellSecond.h"

#import "ShieldInterface.h"

@interface CMRMoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SecondDelegate,ShieldInterfaceDelegate>

@property (nonatomic, strong) ShieldInterface *shieldInter;
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) ContactObject *person;
@property (nonatomic, strong) NSIndexPath *detail_index;
@end
