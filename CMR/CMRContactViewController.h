//
//  CMRContactViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"
#import "CMRSubButton.h"
#import "CMRSubViewController.h"
#import "ContactAndRecentInterface.h"
#import "MessageInterface.h"

@interface CMRContactViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIFolderTableViewDelegate,ContactAndRecentInterfaceDelegate,MessageInterfaceDelegate>

@property (nonatomic, strong) MessageInterface *messageInterface;
@property (nonatomic, strong) NSIndexPath *idxPath;

@property (nonatomic, strong) ContactAndRecentInterface *listInterface;
@property (nonatomic, strong) UIFolderTableView *contactTable;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *contactList;
//搜索
@property (nonatomic, strong) NSMutableDictionary *contactDic;
@property (nonatomic, strong) NSMutableArray *searchByName;
@property (nonatomic, strong) NSMutableArray *searchByPhone;
//筛选
@property (nonatomic, strong) UIBarButtonItem *selectedBtn1;
@property (nonatomic, strong) UIBarButtonItem *selectedBtn2;
//索引
@property (nonatomic, strong) NSMutableDictionary *itemDic;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *names;
@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) UIBarButtonItem *setBtn;
@property (nonatomic, strong) UIButton *sxBtn;
-(void)subViewInfoBtnAction:(CMRSubButton *)btn;
-(void)subViewRecordBtnAction:(CMRSubButton *)btn;
@end
