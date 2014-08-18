//
//  CMRMoreViewController.m
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRMoreViewController.h"
#import "NameViewController.h"

@interface CMRMoreViewController ()

@end

@implementation CMRMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initTableView {
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.myTable.backgroundColor = [UIColor clearColor];
//    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.myTable];
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
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资料设置";
    [self initTableView];
    [self initBackBtn];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([CMRDataService shared].isEditing == YES) {
        self.person = [[CMRDataService shared].temp_contact objectAtIndex:[CMRDataService shared].index_row];
        [self.myTable reloadData];
    }
}
-(void)setPerson:(ContactObject *)person {
    _person = person;
}
-(void)setDetail_index:(NSIndexPath *)detail_index {
    _detail_index = detail_index;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (indexPath.section == 0) {
        static NSString *CellIdentifier_first = @"Cell_first";
        UploadCellFirst *cell = (UploadCellFirst *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier_first];
        if (cell == nil) {
            cell = [[UploadCellFirst alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_first];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"设置备注";
        [cell setPersonObject:self.person];
        return cell;
    }else {
        static NSString *CellIdentifier_second = @"Cell_second";
        UploadCellSecond *cell = (UploadCellSecond *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier_second];
        if (cell == nil) {
            cell = [[UploadCellSecond alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_second];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"屏蔽消息";
        if (self.person.isShield == 0) {
            cell.switchBtn.on = NO;
        }else
            cell.switchBtn.on = YES;
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NameViewController *nameView = nil;
        if (iPhone5) {
            nameView = [[NameViewController alloc]initWithNibName:@"NameViewController" bundle:nil];
        }else {
            nameView = [[NameViewController alloc]initWithNibName:@"NameViewController_iphone4" bundle:nil];
        }
        [nameView setPerson:self.person];
        [nameView setDetail_index:self.detail_index];
        nameView.title = @"备注信息";
        if (![self.person.remark isKindOfClass:[NSNull class]] && self.person.remark!=nil) {
            [nameView  setTxyString:self.person.remark];
        }else {
            [nameView  setTxyString:self.person.name];
        }
        [self.navigationController pushViewController:nameView animated:YES];
    }
}

-(void)setShieldBy:(UISwitch *)aSwitch {
    NSString *isShield = nil;
    if (aSwitch.isOn == YES) {
        isShield = @"1";
        [aSwitch setOn:YES animated:YES];
    }else {
        isShield = @"0";
        [aSwitch setOn:NO animated:YES];
    }
    
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        ShieldInterface *log = [[ShieldInterface alloc]init];
        self.shieldInter = log;
        self.shieldInter.delegate = self;
        [self.shieldInter getShieldInterfaceDelegateWithID:[NSString stringWithFormat:@"%@",self.person.localID] andType:isShield];
        log = nil;
    }
}

-(void)getShieldInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *aDic = [result objectForKey:@"person"];
            ContactObject *contact = [ContactObject userFromDictionary:aDic];
            [[CMRDataService shared].contactList replaceObjectAtIndex:self.detail_index.row withObject:contact];
           [CMRDataService shared].isEditing = YES;
        });
    });
}
-(void)getShieldInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
@end
