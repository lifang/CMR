//
//  SettingViewViewController.m
//  CMR
//
//  Created by comdosoft on 14-2-14.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "SettingViewViewController.h"
#import "SetFirstCell.h"
#define DETAIL_HEADER @"detailHeader"
#import "SelectTimeViewController.h"

@interface SettingViewViewController ()

@end

@implementation SettingViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)initTableView {
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.myTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.myTable];
    [self.myTable registerClass:[SetCellFooter class] forHeaderFooterViewReuseIdentifier:DETAIL_HEADER];
}
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

//返回
-(void)initBackBtn {
    UIButton *l_button_left = [Utils initSimpleButton:CGRectMake(0, 0, 30, 30)
                                                title:@""
                                          normalImage:@"backBtn.png"
                                          highlighted:@"backBtn.png"];
	[l_button_left addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *l_barButtonItem_left = [[UIBarButtonItem alloc] initWithCustomView:l_button_left];
	self.navigationItem.leftBarButtonItem = l_barButtonItem_left;
}
-(void)initFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    UIButton *sendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMessage.frame = CGRectMake(40, 25, 240, 34);
    [sendMessage setBackgroundImage:[UIImage imageNamed:@"chatBtn"] forState:UIControlStateNormal];
    [sendMessage setBackgroundImage:[UIImage imageNamed:@"chatBtnHL"] forState:UIControlStateHighlighted];
    [sendMessage setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [sendMessage setTitle:@"退出当前帐号" forState:UIControlStateHighlighted];
    [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendMessage addTarget:self action:@selector(lonOut:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sendMessage];
    self.myTable.tableFooterView = footerView;
    footerView=nil;
}
//退出
-(void)lonOut:(id)sender {
    AppDelegate *appDel = [AppDelegate shareIntance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user_id"];
    [defaults removeObjectForKey:@"site_id"];
    [defaults removeObjectForKey:@"record"];
    [defaults removeObjectForKey:@"remind"];
    [defaults synchronize];
    
    [appDel showRootView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    [self initTableView];
    [self initFooterView];
    [self initBackBtn];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([CMRDataService shared].isEditing == YES) {
        NSIndexPath *idx = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.myTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idx,nil] withRowAnimation:UITableViewRowAnimationNone];
        [CMRDataService shared].isEditing = NO;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *CellIdentifier_first = @"Cell_set_first";
        SetFirstCell *cell = (SetFirstCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier_first];
        if (cell == nil) {
            cell = [[SetFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_first];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"接受新消息通知";
        NSInteger type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type == 0) {
            cell.nameLab.text = @"已关闭";
        }else
            cell.nameLab.text = @"已开启";
        return cell;
    }else {
        static NSString *CellIdentifier_second = @"Cell_set_second";
        SetSecondCell *cell = (SetSecondCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier_second];
        if (cell == nil) {
            cell = [[SetSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_second];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"消息免打扰设置";
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SetCellFooter *header = (SetCellFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:DETAIL_HEADER];
    if (section==0) {
        header.nameLab.text = @"请在iPhone的“设置”－“通知”中进行修改。";
    }else
        header.nameLab.text = @"开启后，CMR将自动屏蔽选择的时间段的任何提醒。";
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SelectTimeViewController *timeView = nil;
        if (iPhone5) {
            timeView = [[SelectTimeViewController alloc]initWithNibName:@"SelectTimeViewController" bundle:nil];
        }else
            timeView = [[SelectTimeViewController alloc]initWithNibName:@"SelectTimeViewController_iphone4" bundle:nil];
        
        [self.navigationController pushViewController:timeView animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setViewShieldBy:(UISwitch *)aSwitch {
    
}
@end
