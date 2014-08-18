//
//  CMRContactDetailViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-13.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRContactDetailViewController.h"
#import "CMRDetailCell.h"
#import "NameViewController.h"
#import "CMRMoreViewController.h"
#define DETAIL_HEADER @"detailHeader"
#import "CMRSendMessageViewController.h"
@interface CMRContactDetailViewController ()

@end

@implementation CMRContactDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)initTableView {
    self.detailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    self.detailTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.detailTable.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
    [self.view addSubview:self.detailTable];
}
-(void)initFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    UIButton *sendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMessage.frame = CGRectMake(20, 20, 280, 40);
    [sendMessage setBackgroundImage:[UIImage imageNamed:@"chatBtn"] forState:UIControlStateNormal];
    [sendMessage setBackgroundImage:[UIImage imageNamed:@"chatBtnHL"] forState:UIControlStateHighlighted];
    [sendMessage setTitle:@"进入沟通记录" forState:UIControlStateNormal];
    [sendMessage setTitle:@"进入沟通记录" forState:UIControlStateHighlighted];
    [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sendMessage];
    self.detailTable.tableFooterView = footerView;
    footerView=nil;
}
-(void)setUI {
    UIButton *l_button = [[UIButton alloc] init];
//  [l_button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//	[l_button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
	[l_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[l_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	l_button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14.0];
	l_button.titleLabel.textAlignment = NSTextAlignmentCenter;
	l_button.frame = CGRectMake(0, 0, 50, 30);
	[l_button setTitle:@"..." forState:UIControlStateNormal];
    
	[l_button addTarget:self action:@selector(moreViewAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *l_barButtonItem_edit = [[UIBarButtonItem alloc] initWithCustomView:l_button];
    self.moreBtn = l_barButtonItem_edit;
    
    self.navigationItem.rightBarButtonItem = self.moreBtn;
}

- (void)moreViewAction:(id)sender {
    CMRMoreViewController *moreView = nil;
    if (iPhone5) {
        moreView = [[CMRMoreViewController alloc]initWithNibName:@"CMRMoreViewController" bundle:nil];
    }else {
        moreView = [[CMRMoreViewController alloc]initWithNibName:@"CMRMoreViewController_iphone4" bundle:nil];
    }
    [moreView setPerson:self.person];
    [moreView setDetail_index:self.detail_index];
    [self.navigationController pushViewController:moreView animated:YES];
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
#pragma mark   ---------lifetyle----------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"详细资料";
    if (platform>=7.0) {
        AppDelegate *appDel = [AppDelegate shareIntance];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.view.frame = CGRectMake(0, 0, 320, appDel.window.frame.size.height-64);
    }
    [self initTableView];
    [self.detailTable registerClass:[CMRDetailHeader class] forHeaderFooterViewReuseIdentifier:DETAIL_HEADER];
    [self initFooterView];
    [self initBackBtn];
    
    [self setUI];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([CMRDataService shared].isEditing == YES) {
        [self setPerson:[[CMRDataService shared].temp_contact objectAtIndex:[CMRDataService shared].index_row]];
        [self.detailTable reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark   ---------初始化变量----------------
-(NSMutableArray *)infoArray {
    if (!_infoArray) {
        _infoArray = [[NSMutableArray alloc]init];
    }
    return _infoArray;
}
-(void)dealWithString:(NSString *)string {
    NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"%@",string];
    NSString *tempStr1=[mutableStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSString *tempStr3=[tempStr2 stringByReplacingOccurrencesOfString:@"\'" withString:@""];
    NSArray *array = [tempStr3 componentsSeparatedByString:@","];
    if (array.count>0) {
        for (int i=0; i<array.count; i++) {
            NSString *str = [array objectAtIndex:i];
            NSArray *arr = [str componentsSeparatedByString:@"=>"];
            NSString *detailStr = [arr objectAtIndex:1];
            if (detailStr.length>0) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[arr objectAtIndex:1],[arr objectAtIndex:0], nil];
                [self.infoArray addObject:dic];dic = nil;
            }
        }
    }
}
-(void)setPerson:(ContactObject *)person {
    _person = person;
    self.infoArray = nil;
    if (_person.phoneArray) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[_person.phoneArray objectAtIndex:0],@"phone", nil];
        [self.infoArray addObject:dic];dic = nil;
    }
    if (_person.html_content) {
        [self dealWithString:_person.html_content];
    }
}
-(void)setDetail_index:(NSIndexPath *)detail_index {
    _detail_index = detail_index;
}
#pragma mark   ---------tableView协议----------------
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CMRDetailHeader *header = (CMRDetailHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:DETAIL_HEADER];
    if (![self.person.remark isKindOfClass:[NSNull class]] && self.person.remark.length>0) {
        header.nameLab.text = [NSString stringWithFormat:@"%@  (%@)",self.person.name,self.person.remark] ;
    }else
        header.nameLab.text = self.person.name;
    header.person = self.person;
    return header;
}
-(CGSize)getSizeWithString:(NSString *)str{
    UIFont *aFont = [UIFont systemFontOfSize:17];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(210, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.infoArray objectAtIndex:indexPath.row];
    NSString *key = [[dic allKeys] objectAtIndex:0];
    CGSize size = [self getSizeWithString:[dic objectForKey:key]];
    if (size.height+14<=44) {
        return 44;
    }else
        return size.height+14;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"detailCell";
    CMRDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell=[[CMRDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [self.infoArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.lab1.text = @"电话";
        cell.lab2.text = [dic objectForKey:@"phone"];
    }else {
        NSString *key = [[dic allKeys] objectAtIndex:0];
        cell.lab1.text = [NSString stringWithFormat:@"%@",key];
        CGSize size = [self getSizeWithString:[dic objectForKey:key]];
        if (size.height+14<=44) {
            cell.lab2.frame = CGRectMake(100, 7, 210, 30);
        }else
            cell.lab2.frame = CGRectMake(100, 7, 210, size.height);
        cell.lab2.text = [dic objectForKey:key];
    }
    return cell;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NameViewController *nameView = nil;
    if (iPhone5) {
        nameView = [[NameViewController alloc]initWithNibName:@"NameViewController" bundle:nil];
    }else {
        nameView = [[NameViewController alloc]initWithNibName:@"NameViewController_iphone4" bundle:nil];
    }
    
    NSString *title = nil;
    NSDictionary *dic = [self.infoArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        title = @"电话信息";
        [nameView setTxyString:[dic objectForKey:@"phone"]];
    }else {
        NSString *key = [[dic allKeys] objectAtIndex:0];
        title = [NSString stringWithFormat:@"%@信息",key];
        [nameView setTxyString:[dic objectForKey:key]];
    }
    nameView.title = title;
    [nameView setPerson:self.person];
    [nameView setDetail_index:self.detail_index];
    [self.navigationController pushViewController:nameView animated:YES];
}
//发消息
-(void)sendMessage:(id)sender {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MessageInterface *log = [[MessageInterface alloc]init];
        self.messageInterface = log;
        self.messageInterface.delegate = self;
        [self.messageInterface getMessageInterfaceDelegateWithID:[NSString stringWithFormat:@"%@",self.person.localID] andPage:@"1"];
        log = nil;
    }
}

#pragma mark   ---------MessageInterfaceDelegate----------------
-(void)reloadMsgArr {//刷新对应的cell
    self.person.isNewMessage = 0;
    
    [self.detailTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByContact" object:self.person];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByMessage" object:self.person];
}
-(void)getMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AppDelegate *appDel = [AppDelegate shareIntance];
            appDel.navFrom = 0;
            //消息
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            NSArray *array = [result objectForKey:@"message_list"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                CMRMessageObject *message = [CMRMessageObject messageFromDictionary:dic];
                [tempArray addObject:message];
            }
            
            if (self.person.isNewMessage==1) {
                [self reloadMsgArr];
            }
            CMRSendMessageViewController *sendView = nil;
            if (iPhone5) {
                sendView=[[CMRSendMessageViewController alloc]initWithNibName:@"CMRSendMessageViewController" bundle:nil];
            }else {
                sendView=[[CMRSendMessageViewController alloc]initWithNibName:@"CMRSendMessageViewController_iphone4" bundle:nil];
            }
            [sendView setChatPerson:self.person];
            [sendView setMsgRecords:tempArray];
            sendView.page_status = [[result objectForKey:@"page_status"]intValue];
            [sendView setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:sendView animated:YES];
        });
    });
}
-(void)getMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}

@end
