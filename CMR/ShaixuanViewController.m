//
//  ShaixuanViewController.m
//  CMR
//
//  Created by comdosoft on 14-2-20.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "ShaixuanViewController.h"

@interface ShaixuanViewController ()

@end

@implementation ShaixuanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initTableView {
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.myTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.myTable];
}
-(void)initFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(20, 25, 60, 34);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"chatBtn"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"chatBtnHL"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(240, 25, 60, 34);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"chatBtn"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"chatBtnHL"] forState:UIControlStateHighlighted];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sureBtn];
    
    self.myTable.tableFooterView = footerView;
    footerView=nil;
}
-(void)cancelAction:(id)sender {
    [CMRDataService shared].seleted_str = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PDno1" object:nil];
}
-(void)sureAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PDno1" object:nil];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tags = [CMRDataService shared].tag_array;
    if (platform>=7.0) {
        AppDelegate *appDel = [AppDelegate shareIntance];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.view.frame = CGRectMake(0, 0, 320, appDel.window.frame.size.height-64);
    }
    [self initTableView];
    [self initFooterView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tag_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *str = [self.tags objectAtIndex:indexPath.row];
    if ([str isEqualToString:[CMRDataService shared].seleted_str]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastIndexPath = indexPath;
    }
    cell.textLabel.text = str;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    int newRow = [indexPath row];
    int oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row] : -1;
    if(newRow != oldRow){//点击是不同的行
        cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:self.lastIndexPath];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    cell = [tableView cellForRowAtIndexPath:indexPath];
    [CMRDataService shared].seleted_str = [NSString stringWithFormat:@"%@",cell.textLabel.text];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.lastIndexPath = indexPath;
    
}
@end
