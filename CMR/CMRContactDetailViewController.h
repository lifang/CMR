//
//  CMRContactDetailViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-13.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactObject.h"
#import "MessageInterface.h"
#import "CMRDetailHeader.h"

@interface CMRContactDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MessageInterfaceDelegate>

@property (nonatomic, strong) MessageInterface *messageInterface;

@property (nonatomic, strong) UITableView *detailTable;
@property (nonatomic, strong) ContactObject *person;
@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, strong) UIBarButtonItem *moreBtn;
@property (nonatomic, strong) NSIndexPath *detail_index;
@end
