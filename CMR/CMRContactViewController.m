//
//  CMRContactViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRContactViewController.h"
#import "CMRManager.h"
#import "ContactObject.h"
#import "pinyin.h"
#import "NSDictionary-MutableDeeepCopy.h"
#import "CMRContactDetailViewController.h"
#import "CMRPersonCell.h"
#import "CMRSendMessageViewController.h"
#import "SettingViewViewController.h"

#import "ShaixuanViewController.h"
@interface CMRContactViewController ()
@end

@implementation CMRContactViewController

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
        self.title = NSLocalizedString(@"通讯录", @"通讯录");
        self.tabBarItem.image = [UIImage imageNamed:@"person"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"personHL"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadByMessage:) name:@"reloadByMessage" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadByChatDelete:) name:@"reloadByChatDelete" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadByChatAdd:) name:@"reloadByChatAdd" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadByMessageAdd:) name:@"reloadByMessageAdd" object:nil];
        
        
        [self tableViewInit];
        [self searchBarInit];
        [self setUI];
    }
    return self;
}
-(void)buttonAble:(NSNotification *)notification {
    if ([CMRDataService shared].seleted_str) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        NSMutableArray *array = [CMRDataService shared].contactList;
        for (int i=0; i<array.count; i++) {
            ContactObject *contact = (ContactObject *)[array objectAtIndex:i];
            if ([contact.tags containsObject:[CMRDataService shared].seleted_str]) {
                [tempArray addObject:contact];
            }
        }
        if (tempArray.count>0) {
            [self initDataWithArray:tempArray];
            [self.contactTable reloadData];
        }else {
            
            [Utils errorAlert:[NSString stringWithFormat:@"暂无标签为“%@”的记录",[CMRDataService shared].seleted_str]];
        }
        
    }else {
        [self initDataWithArray:[CMRDataService shared].contactList];
        [self.contactTable reloadData];
    }
}
-(void)setUI {
    UIButton *l_button = [[UIButton alloc] init];
    [l_button setBackgroundImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
	[l_button setBackgroundImage:[UIImage imageNamed:@"set_HL"] forState:UIControlStateHighlighted];
	[l_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[l_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	l_button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14.0];
	l_button.titleLabel.textAlignment = NSTextAlignmentCenter;
	l_button.frame = CGRectMake(0, 0, 50, 30);
//	[l_button setTitle:@"设置" forState:UIControlStateNormal];
    
	[l_button addTarget:self action:@selector(settingViewAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *l_barButtonItem_edit = [[UIBarButtonItem alloc] initWithCustomView:l_button];
    self.setBtn = l_barButtonItem_edit;
    self.navigationItem.rightBarButtonItem = self.setBtn;
}
//索引---取消或更改搜索条件
-(void)resetSearch{
    self.names = nil;self.keys=nil;
    NSMutableDictionary *allNamesCopy = [self.itemDic mutableDeepCopy];
    self.names = allNamesCopy;
    
    NSMutableArray *keyArray = [[NSMutableArray alloc]init];
    [keyArray addObjectsFromArray:[[self.itemDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
    keyArray = nil;
}
#pragma mark   ---------初始化控件----------------
//tableView初始化
- (void)tableViewInit {
    CGRect frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);//iphone4-6.0
    DLog(@"%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.height);
    self.contactTable = [[UIFolderTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.contactTable.delegate = self;
    self.contactTable.dataSource = self;
    self.contactTable.folderDelegate = self;
    [self.contactTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	self.contactTable.backgroundColor=[UIColor whiteColor];
    //改变索引的颜色
    self.contactTable.sectionIndexColor = [UIColor blackColor];
    if (platform>=7.0) {
        self.contactTable.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    
    //下拉刷新
    __block CMRContactViewController *manView = self;
    __block UIFolderTableView *table = self.contactTable;
    [_contactTable addPullToRefreshWithActionHandler:^{
        [manView refreshData];
        [table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
    
    [self.view addSubview:self.contactTable];
}

//searchBar初始化
- (void)searchBarInit {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 44.0f)];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.searchBar.backgroundColor=[UIColor clearColor];
	self.searchBar.translucent=YES;
	self.searchBar.placeholder=@"搜索";
	self.searchBar.delegate = self;
	self.searchBar.barStyle=UIBarStyleDefault;
    UIView *headerView = [[UIView alloc] initWithFrame: self.searchBar.frame];
    [headerView addSubview:self.searchBar];
    
    self.sxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sxBtn.frame =CGRectMake(280.0f, 0.0f, 40.0f, 44.0f);
    [self.sxBtn addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sxBtn.backgroundColor = [UIColor clearColor];
    [self.sxBtn setImage:[UIImage imageNamed:@"sx"] forState:UIControlStateNormal];
    [self.sxBtn setImage:[UIImage imageNamed:@"sx_HL"] forState:UIControlStateHighlighted];
    [self.sxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sxBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.sxBtn];
    
    [self.view addSubview:headerView];
}
#pragma --筛选
-(void)shaixuanAction:(id)sender {
    [self resetTable];
    ShaixuanViewController *sxView = [[ShaixuanViewController alloc]initWithNibName:@"ShaixuanViewController" bundle:nil];
    
    [self presentViewController:sxView animated:YES completion:nil];
}
-(void)initDataWithArray:(NSMutableArray *)array {
    [CMRDataService shared].temp_contact = array;
    self.sectionArray = nil;self.contactDic = nil;self.itemDic = nil;
    //索引
    for (int i = 0; i < 27; i++)
        [self.sectionArray addObject:[NSMutableArray array]];
    NSString *nameSection = nil;
    
    for (int i=0; i<array.count; i++) {
        //搜索
        ContactObject *contact = (ContactObject *)[array objectAtIndex:i];
        //添加到搜索库
        [[CMRManager sharedService] AddContact:contact.localID name:contact.name phone:contact.phoneArray];
        [self.contactDic setObject:contact forKey:contact.localID];
        //索引
        NSString *firstLetter = [contact.name substringWithRange:NSMakeRange(0, 1)];
        NSString *emailRegex = @"[\u4E00-\u9FFF]";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:firstLetter]) {//汉字
            nameSection = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([contact.name characterAtIndex:0])] uppercaseString];
        }else {
            NSString *emailRegex2 = @"^[a-zA-Z]+$";
            NSPredicate *emailTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex2];
            if ([emailTest2 evaluateWithObject:firstLetter]) {//字母
                nameSection = [firstLetter uppercaseString];
            }else {
                nameSection = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([contact.name characterAtIndex:0])] uppercaseString];
            }
        }
        NSUInteger firstLetterLoc = [ALPHA rangeOfString:[nameSection substringToIndex:1]].location;
        if (firstLetterLoc != NSNotFound)
            [[self.sectionArray objectAtIndex:firstLetterLoc] addObject:contact];
        
        [self.itemDic setObject:[self.sectionArray objectAtIndex:firstLetterLoc] forKey:nameSection ];
    }
    [self resetSearch];
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
        [self.listInterface getContactAndRecentInterfaceDelegateWithType:@"0"];
        log = nil;
    }
}
#pragma mark   ---------lifeStyle----------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"移动CMR";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonAble:) name:@"PDno1" object:nil];
}
- (void)settingViewAction:(id)sender {
    SettingViewViewController *setView = nil;
    if (iPhone5) {
        setView = [[SettingViewViewController alloc]initWithNibName:@"SettingViewViewController" bundle:nil];
    }else {
        setView = [[SettingViewViewController alloc]initWithNibName:@"SettingViewViewController_iphone4" bundle:nil];
    }
    
    [setView setHidesBottomBarWhenPushed:YES];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:setView animated:YES];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.searchBar.delegate = self;
    
    AppDelegate *appDel = [AppDelegate shareIntance];
    if (appDel.isLoging == NO && appDel.isFirst == NO) {
        [self refreshData];
        appDel.isFirst = YES;
    }else {
        if ([CMRDataService shared].seleted_str) {
            [self initDataWithArray:[CMRDataService shared].temp_contact];
        }else {
            [self initDataWithArray:[CMRDataService shared].contactList];
        }
    }
    
    if ([CMRDataService shared].isEditing == YES) {
        [self initDataWithArray:[CMRDataService shared].temp_contact];
        [self.contactTable reloadData];
        [CMRDataService shared].isEditing = NO;
    }
}

- (void)reloadByChatDelete:(NSNotification *)notification {
    ContactObject *contact = [notification object];
    for (int i=0; i<self.keys.count; i++) {
        NSString *key = [self.keys objectAtIndex:i];
        NSMutableArray *namesSection = [NSMutableArray arrayWithArray:[self.names objectForKey:key]];
        for (int j=0; j<namesSection.count; j++) {
            ContactObject *contact2 = (ContactObject *)[namesSection objectAtIndex:j];
            if ([contact.localID intValue] == [contact2.localID intValue]){
                contact2.isMakeRemind = 0;
                [namesSection replaceObjectAtIndex:j withObject:contact2];
                [self.names setObject:namesSection forKey:key];
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.contactTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
}
- (void)reloadByMessageAdd:(NSNotification *)notification {
    NSString *uid = [notification object];
    for (int i=0; i<self.keys.count; i++) {
        NSString *key = [self.keys objectAtIndex:i];
        NSMutableArray *namesSection = [NSMutableArray arrayWithArray:[self.names objectForKey:key]];
        for (int j=0; j<namesSection.count; j++) {
            ContactObject *contact2 = (ContactObject *)[namesSection objectAtIndex:j];
            if ([uid intValue] == [contact2.localID intValue]) {
                if (contact2.isNewMessage == 1) {
                    
                }else {
                    contact2.isNewMessage = 1;
                    [namesSection replaceObjectAtIndex:j withObject:contact2];
                    [self.names setObject:namesSection forKey:key];
                    
                    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:j inSection:i];
                    [self.contactTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
                break;
            }
        }
    }
}
- (void)reloadByChatAdd:(NSNotification *)notification {
    ContactObject *contact = [notification object];
    for (int i=0; i<self.keys.count; i++) {
        NSString *key = [self.keys objectAtIndex:i];
        NSMutableArray *namesSection = [NSMutableArray arrayWithArray:[self.names objectForKey:key]];
        for (int j=0; j<namesSection.count; j++) {
            ContactObject *contact2 = (ContactObject *)[namesSection objectAtIndex:j];
            if ([contact.localID intValue] == [contact2.localID intValue]){
                contact2.isMakeRemind = 1;
                [namesSection replaceObjectAtIndex:j withObject:contact2];
                [self.names setObject:namesSection forKey:key];
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.contactTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
}
- (void)reloadByMessage:(NSNotification *)notification {
    ContactObject *contact = [notification object];
    for (int i=0; i<self.keys.count; i++) {
        NSString *key = [self.keys objectAtIndex:i];
        NSMutableArray *namesSection = [NSMutableArray arrayWithArray:[self.names objectForKey:key]];
        for (int j=0; j<namesSection.count; j++) {
            ContactObject *contact2 = (ContactObject *)[namesSection objectAtIndex:j];
            if ([contact.localID intValue] == [contact2.localID intValue]) {
                contact2.isNewMessage = 0;
                [namesSection replaceObjectAtIndex:j withObject:contact2];
                [self.names setObject:namesSection forKey:key];
                
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.contactTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
}
#pragma mark   ---------初始化变量----------------
-(NSMutableDictionary *)contactDic {
    if (!_contactDic) {
        _contactDic = [[NSMutableDictionary alloc]init];
    }
    return _contactDic;
}
-(NSMutableDictionary *)itemDic {
    if (!_itemDic) {
        _itemDic = [[NSMutableDictionary alloc]init];
    }
    return _itemDic;
}
-(NSMutableDictionary *)names {
    if (!_names) {
        _names = [[NSMutableDictionary alloc]init];
    }
    return _names;
}
-(NSMutableArray *)searchByName {
    if (!_searchByName) {
        _searchByName = [[NSMutableArray alloc]init];
    }
    return _searchByName;
}
-(NSMutableArray *)searchByPhone {
    if (!_searchByPhone) {
        _searchByPhone = [[NSMutableArray alloc]init];
    }
    return _searchByPhone;
}
-(NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [[NSMutableArray alloc]init];
    }
    return _sectionArray;
}
-(NSMutableArray *)keys {
    if (!_keys) {
        _keys = [[NSMutableArray alloc]init];
    }
    return _keys
    ;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark   ---------tableView协议----------------

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
	return index;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.searchBar.text length] <= 0){
        return ([self.keys count] > 0 ? [self.keys count] : 1);
    }else
        return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.searchBar.text length] <= 0) {
        if([self.keys count] == 0)
            return 0;
        NSString *key = [self.keys objectAtIndex:section];//提取键
        NSArray *namesSection = [self.names objectForKey:key];//提取键对应的值
        return [namesSection count];
    }else {
        self.contactTable.sectionIndexColor = [UIColor clearColor];
        return [self.searchByName count] + [self.searchByPhone count];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.searchBar.text.length<=0) {
        if([self.keys count] == 0)
            return nil;
        
        NSString *key = [self.keys objectAtIndex:section];
        if(key == UITableViewIndexSearch)
            return nil;
        return  key;
    }else
        return nil;
}

//索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.keys;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
	[tableView reloadData];
    return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"personCell";
    CMRPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell=[[CMRPersonCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.searchBar.text length] <= 0) {
        NSString *key = [self.keys objectAtIndex:indexPath.section];
        NSArray *namesSection = [self.names objectForKey:key];
        ContactObject *contact = (ContactObject *)[namesSection objectAtIndex:indexPath.row];
        cell.isSearch = NO;
        if (isHidden==YES) {
            cell.isSearch=YES;
        }
        [cell setPerson:contact];
        if (![contact.remark isKindOfClass:[NSNull class]] && contact.remark!=nil && contact.remark.length>0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@  (%@)",contact.name,contact.remark] ;
        }else
            cell.textLabel.text = contact.name;
        cell.detailTextLabel.text = @"";
        cell.textLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    if (indexPath.row < [self.searchByName count]) {
        localID = [self.searchByName objectAtIndex:indexPath.row];
        
        //姓名匹配 获取对应匹配的拼音串 及高亮位置
        if ([self.searchBar.text length]) {
            [[CMRManager sharedService] GetPinYin:localID pinYin:matchString matchPos:matchPos];
        }
    } else {
        localID = [self.searchByPhone objectAtIndex:indexPath.row-[self.searchByName count]];
        NSMutableArray *matchPhones = [NSMutableArray array];
        
        //号码匹配 获取对应匹配的号码串 及高亮位置
        if ([self.searchBar.text length]) {
            [[CMRManager sharedService] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
            [matchString appendString:[matchPhones objectAtIndex:0]];
        }
    }
    ContactObject *contact = [self.contactDic objectForKey:localID];
    cell.isSearch= YES;
    if (isHidden==YES) {
        cell.isSearch=YES;
    }
    cell.person = contact;
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = matchString;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
static bool isHidden=NO;
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDel = [AppDelegate shareIntance];
    appDel.viewFrom = 0;
    
    [self.searchBar resignFirstResponder];
    isHidden=YES;
    [self.contactTable reloadData];
    //拉开的子view
    CMRSubViewController *subView = [[CMRSubViewController alloc]initWithNibName:@"CMRSubViewController" bundle:nil];
    ContactObject *contact = nil;
    if ([self.searchBar.text length] <= 0) {
        NSString *key = [self.keys objectAtIndex:indexPath.section];
        NSArray *namesSection = [self.names objectForKey:key];
        contact = (ContactObject *)[namesSection objectAtIndex:indexPath.row];
    }else {
        NSNumber *localID = nil;
        NSMutableString *matchString = [NSMutableString string];
        NSMutableArray *matchPos = [NSMutableArray array];
        if (indexPath.row < [self.searchByName count]) {
            localID = [self.searchByName objectAtIndex:indexPath.row];
            //姓名匹配 获取对应匹配的拼音串 及高亮位置
            if ([self.searchBar.text length]) {
                [[CMRManager sharedService] GetPinYin:localID pinYin:matchString matchPos:matchPos];
            }
        } else {
            localID = [self.searchByPhone objectAtIndex:indexPath.row-[self.searchByName count]];
            NSMutableArray *matchPhones = [NSMutableArray array];
            //号码匹配 获取对应匹配的号码串 及高亮位置
            if ([self.searchBar.text length]) {
                [[CMRManager sharedService] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
                [matchString appendString:[matchPhones objectAtIndex:0]];
            }
        }
        contact = [self.contactDic objectForKey:localID];
    }
    subView.person = contact;
    subView.idxPath = indexPath;
    subView.contactView = self;
    self.contactTable.scrollEnabled= NO;
    //改变索引的颜色
    self.contactTable.sectionIndexColor = [UIColor clearColor];
    
    UIFolderTableView *folderTableView = (UIFolderTableView *)self.contactTable;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:subView.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                }
                           completionBlock:^{
                               self.contactTable.scrollEnabled= YES;
                               self.contactTable.sectionIndexColor = [UIColor blackColor];
                               isHidden=NO;
                               [self.contactTable reloadData];
                           }];
}
-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 22;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.searchBar.text.length<=0) {
        self.searchBar.showsCancelButton = NO;
        self.contactTable.sectionIndexColor = [UIColor blackColor];
    }else {
        self.contactTable.sectionIndexColor = [UIColor clearColor];
    }
    [self.searchBar resignFirstResponder];
    
}
- (void)tableViewWillReloadData:(UITableView *)tableView {
    
}
- (void)tableViewDidReloadData:(UITableView *)tableView {
}
#pragma mark   ---------searchBar协议----------------
- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)searchText
{
    [[CMRManager sharedService] Search:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
    [self.contactTable reloadData];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)search{
    self.searchBar.showsCancelButton = YES;
    self.contactTable.sectionIndexColor = [UIColor clearColor];
    if (platform>=7.0) {
        for(id cc in [self.searchBar subviews]) {
            if([cc isKindOfClass:[UIView class]]) {
                UIView *cc_view = (UIView *)cc;
                for (id vv in [cc_view subviews]){
                    if([vv isKindOfClass:[UIButton class]]){
                        UIButton *btn = (UIButton *)vv;
                        [btn setTitle:@"取消"  forState:UIControlStateNormal];
                        [btn setTintColor:[UIColor blackColor]];
                    }
                }
            }
        }
    }else {
        for(id cc in [self.searchBar subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTintColor:[UIColor blackColor]];
            }
        }
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)search{
    self.searchBar.showsCancelButton=NO;
    self.searchBar.text=nil;
    [self.searchBar resignFirstResponder];
    self.contactTable.sectionIndexColor = [UIColor blackColor];
    [self.contactTable reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
    if (self.searchBar.text.length<=0) {
        [Utils errorAlert:@"搜索内容不能为空!"];
    }
}
#pragma mark   ---------button点击事件----------------
-(void)resetTable {
    UIFolderTableView *folderTableView = (UIFolderTableView *)self.contactTable;
    [folderTableView closeTheDoor];
    self.contactTable.scrollEnabled= YES;
    self.contactTable.sectionIndexColor = [UIColor blackColor];
    isHidden=NO;
}
//查看信息
-(void)subViewInfoBtnAction:(CMRSubButton *)btn {
    [self resetTable];
    CMRContactDetailViewController *detailView = nil;
    if (iPhone5) {
        detailView = [[CMRContactDetailViewController alloc]initWithNibName:@"CMRContactDetailViewController" bundle:nil];
    }else {
        detailView = [[CMRContactDetailViewController alloc]initWithNibName:@"CMRContactDetailViewController_iphone4" bundle:nil];
    }
    [detailView setPerson:btn.person];
    [detailView setDetail_index:btn.index];
    [detailView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailView animated:YES];
}
//往来记录
-(void)subViewRecordBtnAction:(CMRSubButton *)btn {
    [self resetTable];
    
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        self.idxPath= btn.index;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MessageInterface *log = [[MessageInterface alloc]init];
        self.messageInterface = log;
        self.messageInterface.delegate = self;
        [self.messageInterface getMessageInterfaceDelegateWithID:[NSString stringWithFormat:@"%@",btn.person.localID] andPage:@"1"];
        log = nil;
    }
}
#pragma mark   ---------ContactAndRecentInterfaceDelegate----------------
-(void)getListInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //通讯录
            [CMRDataService shared].contactList = [[NSMutableArray alloc]init];
            NSArray *array_contact = [result objectForKey:@"person_list"];
            for (int i=0; i<array_contact.count; i++) {
                NSDictionary *dic = [array_contact objectAtIndex:i];
                ContactObject *contact = [ContactObject userFromDictionary:dic];
                [[CMRDataService shared].contactList addObject:contact];
            }
            [self initDataWithArray:[CMRDataService shared].contactList];
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = self.selectedBtn1;
            [self.contactTable reloadData];
        });
    });
}
-(void)getListInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
#pragma mark   ---------MessageInterfaceDelegate----------------
-(void)reloadMsgArr {//刷新对应的cell
    NSString *key = [self.keys objectAtIndex:self.idxPath.section];
    NSMutableArray *namesSection = [NSMutableArray arrayWithArray:[self.names objectForKey:key]];
    ContactObject *contact = (ContactObject *)[namesSection objectAtIndex:self.idxPath.row];
    contact.isNewMessage = 0;
    
    [namesSection replaceObjectAtIndex:self.idxPath.row withObject:contact];
    [self.names setObject:namesSection forKey:key];
    [self.contactTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByContact" object:contact];
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
            NSString *key = [self.keys objectAtIndex:self.idxPath.section];
            NSArray *namesSection = [self.names objectForKey:key];
            ContactObject *contact = (ContactObject *)[namesSection objectAtIndex:self.idxPath.row];
            
            if (contact.isNewMessage==1) {
                [self reloadMsgArr];
            }
            CMRSendMessageViewController *sendView = nil;
            if (iPhone5) {
                sendView=[[CMRSendMessageViewController alloc]initWithNibName:@"CMRSendMessageViewController" bundle:nil];
            }else {
                sendView=[[CMRSendMessageViewController alloc]initWithNibName:@"CMRSendMessageViewController_iphone4" bundle:nil];
            }
            [sendView setChatPerson:contact];
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
