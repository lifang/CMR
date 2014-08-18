//
//  CMRMessageViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactObject.h"
#import "MessageInterface.h"
#import "CMRMessageUserUnionObject.h"
#import "ContactAndRecentInterface.h"
#import "DeleteInterface.h"

@interface CMRMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MessageInterfaceDelegate,ContactAndRecentInterfaceDelegate,DeleteInterfaceDelegate>

@property (nonatomic, strong) DeleteInterface *deleteInterface;
@property (nonatomic, strong) ContactAndRecentInterface *listInterface;
@property (nonatomic, strong) MessageInterface *messageInterface;
@property (nonatomic, strong) NSMutableArray *msgArr;
@property (nonatomic, strong) UITableView *messageTable;

@property (nonatomic, strong) NSIndexPath *idxPath;
@end
