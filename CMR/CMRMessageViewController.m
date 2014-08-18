//
//  CMRMessageViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRMessageViewController.h"
#import "CMRRecentListCell.h"
#import "CMRSendMessageViewController.h"
#import "CMRMessageObject.h"

@interface CMRMessageViewController ()

@end

@implementation CMRMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (platform>=7.0) {
            AppDelegate *appDel = [AppDelegate shareIntance];
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = YES;
            self.view.frame = CGRectMake(0, 0, 320, appDel.window.frame.size.height-64-49);
        }
        self.title = NSLocalizedString(@"消息", @"消息");
        self.tabBarItem.image = [UIImage imageNamed:@"message"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"messageHL"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadByContact:) name:@"reloadByContact" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecentContactList:) name:@"reloadRecentContactList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadList:) name:@"reloadList" object:nil];
        [self tableViewInit];
    }
    return self;
}
- (void)tableViewInit {
    self.messageTable = [[UIFolderTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.messageTable.delegate = self;
    self.messageTable.dataSource = self;
    self.messageTable.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
    [self.messageTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //下拉刷新
    __block CMRMessageViewController *manView = self;
    __block UITableView *table = self.messageTable;
    [_messageTable addPullToRefreshWithActionHandler:^{
        [manView refreshData];
        [table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
    [self.view addSubview:self.messageTable];
}
-(ContactObject *)returnContact {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"505",@"id",@"邱成西",@"name",@"18551109693",@"phone",nil];
    ContactObject *contact = [ContactObject userFromDictionary:dic];
    return contact;
}
#pragma mark   ---------刷新列表----------------
-(void)refreshData {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        ContactAndRecentInterface *log = [[ContactAndRecentInterface alloc]init];
        self.listInterface = log;
        self.listInterface.delegate = self;
        [self.listInterface getContactAndRecentInterfaceDelegateWithType:@"1"];
        log = nil;
    }
}
#pragma mark   ---------lifeStyle----------------
-(void)initData {
    self.msgArr = [CMRDataService shared].messageList;
    
    int count = 0;
    for (int i=0; i<[CMRDataService shared].messageList.count; i++) {
        CMRMessageUserUnionObject *unionObject = [[CMRDataService shared].messageList objectAtIndex:i];
        if ([unionObject.message.messageStatus intValue]==1) {
            count ++;
        }
    }
    if (count==0) {
        self.tabBarItem.badgeValue = nil;
    }else {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appDel = [AppDelegate shareIntance];
    if (appDel.isLoging == NO && appDel.isSecond == NO) {
        [self refreshData];
        appDel.isSecond = YES;
    }
}
-(void)reloadRecentContactList:(NSNotification *)notification {
    CMRMessageUserUnionObject *unionObject = [notification object];
    BOOL exit = NO;
    int i=0;
    while (i<self.msgArr.count) {
        CMRMessageUserUnionObject *unionObject2 = [self.msgArr objectAtIndex:i];
        if ([unionObject.user.localID intValue] == [unionObject2.user.localID intValue]) {
            exit = YES;
            [self.msgArr replaceObjectAtIndex:i withObject:unionObject];
            [self.messageTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:i inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        i++;
    }
    if (exit == NO) {
        [self.msgArr addObject:unionObject];
        [self.messageTable reloadData];
    }

}
- (void)reloadByContact:(NSNotification *)notification {
    ContactObject *contact = [notification object];
    for (int i=0; i<self.msgArr.count; i++) {
        CMRMessageUserUnionObject *unionObject = [self.msgArr objectAtIndex:i];
        if ([contact.localID intValue] == [unionObject.user.localID intValue]) {
            unionObject.message.messageStatus = @"0";
            [self.msgArr replaceObjectAtIndex:i withObject:unionObject];
            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.messageTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    int count = [self.tabBarItem.badgeValue intValue];
    if (count==0) {
        
    }else {
        count = count-1;
        if (count<=0) {
            self.tabBarItem.badgeValue = nil;
        }else
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
    }
}

- (void)reloadList:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    BOOL isExit = NO;
    for (int i=0; i<self.msgArr.count; i++) {
        CMRMessageUserUnionObject *unionObject = [self.msgArr objectAtIndex:i];
        if ([[dic objectForKey:@"sound"] intValue] == [unionObject.user.localID intValue]) {
            isExit = YES;
            NSString *str = [dic objectForKey:@"alert"];
            NSRange range_sub = [str rangeOfString:@":"];
            if (range_sub.location != NSNotFound) {
                NSString *str2 = [str substringWithRange:NSMakeRange(range_sub.location+range_sub.length, str.length-range_sub.location-range_sub.length)];
                DLog(@"str2 = %@",str2);
                unionObject.message.messageContent = str2;
            }
            unionObject.message.messageDate = [Utils getNowDateFromatAnDate];
            if ([unionObject.message.messageStatus intValue]== 1) {
                
            }else {
                unionObject.message.messageStatus = @"1";
            }
            [self.msgArr replaceObjectAtIndex:i withObject:unionObject];
            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.messageTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
        }
    }
    if (isExit == NO) {
        DLog(@"111");
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark   ---------初始化变量----------------
-(NSMutableArray *)msgArr {
    if (!_msgArr) {
        _msgArr = [[NSMutableArray alloc]init];
    }
    return _msgArr;
}
#pragma mark   ---------tableView协议----------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"messageCell";
    CMRRecentListCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[CMRRecentListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    CMRMessageUserUnionObject *unionObject=[self.msgArr objectAtIndex:indexPath.row];
    [cell setUnionObject:unionObject];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        CMRMessageUserUnionObject *unionObj=[self.msgArr objectAtIndex:indexPath.row];
        self.idxPath = indexPath;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MessageInterface *log = [[MessageInterface alloc]init];
        self.messageInterface = log;
        self.messageInterface.delegate = self;
        [self.messageInterface getMessageInterfaceDelegateWithID:[NSString stringWithFormat:@"%@",unionObj.user.localID] andPage:@"1"];
        log = nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            CMRMessageUserUnionObject *unionObject = [self.msgArr objectAtIndex:indexPath.row];
            self.idxPath = indexPath;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            DeleteInterface *log = [[DeleteInterface alloc]init];
            self.deleteInterface = log;
            self.deleteInterface.delegate = self;
            [self.deleteInterface getDeleteInterfaceDelegateWithID:[NSString stringWithFormat:@"%@",unionObject.user.localID]];
            log = nil;
        }
    }
}
#pragma mark   ---------MessageInterfaceDelegate----------------
-(void)reloadMsgArr {//刷新对应的cell
    CMRMessageUserUnionObject *unionObj=[self.msgArr objectAtIndex:self.idxPath.row];
    unionObj.message.messageStatus = [NSString stringWithFormat:@"%d",0];
    [self.msgArr replaceObjectAtIndex:self.idxPath.row withObject:unionObj];
    [self.messageTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    int count = [self.tabBarItem.badgeValue intValue];
    count = count-1;
    if (count<=0) {
        self.tabBarItem.badgeValue = nil;
    }else
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByMessage" object:unionObj.user];
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

            CMRMessageUserUnionObject *unionObj=[self.msgArr objectAtIndex:self.idxPath.row];
            if ([unionObj.message.messageStatus intValue]==1) {
                [self reloadMsgArr];
            }
            CMRSendMessageViewController *sendView = nil;
            if (iPhone5) {
                sendView=[[CMRSendMessageViewController alloc]initWithNibName:@"CMRSendMessageViewController" bundle:nil];
            }else {
                sendView=[[CMRSendMessageViewController alloc]initWithNibName:@"CMRSendMessageViewController_iphone4" bundle:nil];
            }
            [sendView setChatPerson:unionObj.user];
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

#pragma mark   ---------ContactAndRecentInterfaceDelegate----------------
-(void)getListInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //最近联系人
            [CMRDataService shared].messageList = [[NSMutableArray alloc]init];
            NSArray *array_message = [result objectForKey:@"recent_list"];
            for (int i=0; i<array_message.count; i++) {
                NSDictionary *dic = [array_message objectAtIndex:i];
                CMRMessageObject *message = [CMRMessageObject messageFromDictionary:dic];
                
                NSString *person_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"person_id"]];
                for (ContactObject *contact in [CMRDataService shared].contactList) {
                    if ([contact.localID intValue] == [person_id intValue]) {
                        CMRMessageUserUnionObject *unionObject = [CMRMessageUserUnionObject unionWithMessage:message andUser:contact];
                        [[CMRDataService shared].messageList addObject:unionObject];
                    }
                }
            }
            [self initData];
            [self.messageTable reloadData];
        });
    });
}
-(void)getListInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
#pragma mark   ---------DeleteInterfaceDelegate----------------
-(void)getDeleteInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.msgArr removeObjectAtIndex:self.idxPath.row];
            [self.messageTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:self.idxPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}
-(void)getDeleteInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
@end
