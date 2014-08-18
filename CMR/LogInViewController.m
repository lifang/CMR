//
//  LogInViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-22.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "LogInViewController.h"
#import "CMRMessageViewController.h"
#import "CMRContactViewController.h"
@interface LogInViewController ()

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark   ---------lifeStyle----------------
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (iPhone5) {
        DLog(@"iphone5");
    }else {
        //监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    }
}
- (void)keyBoardWillShow:(id)sender{
    CGRect frame = self.loginView.frame;
    [UIView beginAnimations:nil context:nil];
    if (frame.origin.y == 60) {
        frame.origin.y = 20;
    }
    self.loginView.frame = frame;
    [UIView commitAnimations];
}

- (void)keyBoardWillHide:(id)sender{
    CGRect frame = self.loginView.frame;
    [UIView beginAnimations:nil context:nil];
    if (frame.origin.y== 20) {
        frame.origin.y = 60;
    }
    self.loginView.frame = frame;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)checkForm{
    NSString *passport = [[NSString alloc] initWithString: self.txtName.text?:@""];
    NSString *password = [[NSString alloc] initWithString: self.txtPwd.text?:@""];
    NSString *msgStr = @"";
    if (msgStr.length == 0) {
        if (passport.length == 0){
            msgStr = @"请输入用户名";
            [self.txtName becomeFirstResponder];
        }else {
            NSString *regexCall = @"1[0-9]{10}";
            NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
            if ([predicateCall evaluateWithObject:self.txtName.text]) {
                [self.txtName resignFirstResponder];
            }else {
                [self.txtName becomeFirstResponder];
                msgStr = @"请输入准确的用户名";
            }
        }
    }
    if (password.length == 0){
        msgStr = @"请输入密码";
        [self.txtPwd becomeFirstResponder];
    }
    if (msgStr.length > 0){
        [Utils errorAlert:msgStr];
        return FALSE;
    }
    return TRUE;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.txtName resignFirstResponder];
    [self.txtPwd resignFirstResponder];
}
- (IBAction)clickLogin:(id)sender{
//    BOOL success =[self checkForm];
//    if (success) {
    [self.txtName resignFirstResponder];
    [self.txtPwd resignFirstResponder];
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            AppDelegate *appDel = [AppDelegate shareIntance];
            LogInterface *log = [[LogInterface alloc]init];
            self.logInterface = log;
            self.logInterface.delegate = self;
            [self.logInterface getLogInterfaceDelegateWithName:self.txtName.text andPassWord:self.txtPwd.text andToken:appDel.pushstr];
            log = nil;
        }
//    }
}

#pragma mark   ---------LogInterface----------------
-(void)getLogInfoDidFinished:(NSDictionary *)result {
    AppDelegate *appDel = [AppDelegate shareIntance];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"record"]isKindOfClass:[NSNull class]] && [result objectForKey:@"record"]!=nil) {
                [CMRDataService shared].recordModel = [result objectForKey:@"record"];//记录模版
            }else {
                [CMRDataService shared].recordModel = nil;
            }
            if (![[result objectForKey:@"remind"]isKindOfClass:[NSNull class]] && [result objectForKey:@"remind"]!=nil) {
                [CMRDataService shared].remindModel = [result objectForKey:@"remind"];//提醒模版
            }else {
                [CMRDataService shared].remindModel = nil;
            }
            
            [CMRDataService shared].tag_array = [NSMutableArray arrayWithArray:[result objectForKey:@"tags"]];
            //登录
            [CMRDataService shared].user_id = [NSString stringWithFormat:@"%@",[result objectForKey:@"user_id"]];
            [CMRDataService shared].site_id = [NSString stringWithFormat:@"%@",[result objectForKey:@"site_id"]];
            if (![[result objectForKey:@"receive_status"]isKindOfClass:[NSNull class]]) {
                [CMRDataService shared].flag = [[result objectForKey:@"receive_status"]integerValue];
            }
            if (![[result objectForKey:@"receive_start"]isKindOfClass:[NSNull class]] && [result objectForKey:@"receive_start"]!=nil) {
                [CMRDataService shared].strat_time = [NSString stringWithFormat:@"%@",[result objectForKey:@"receive_start"]];
            }else {
                [CMRDataService shared].strat_time = nil;
            }
            if (![[result objectForKey:@"receive_end"]isKindOfClass:[NSNull class]] && [result objectForKey:@"receive_end"]!=nil) {
                [CMRDataService shared].end_time = [NSString stringWithFormat:@"%@",[result objectForKey:@"receive_end"]];
            }else {
                [CMRDataService shared].end_time = nil;
            }
            
            
            if (![[result objectForKey:@"site_auth"]isKindOfClass:[NSNull class]]) {
                [CMRDataService shared].jurisdiction = [[result objectForKey:@"site_auth"]integerValue];
            }
            
            
            if ([CMRDataService shared].jurisdiction == 1) {
                [CMRDataService shared].headSize = 40;
            }else {
                [CMRDataService shared].headSize = 0;
            }
            
            //表示app登录状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"isOn"];
            [defaults setObject:[CMRDataService shared].user_id forKey:@"user_id"];
            [defaults setObject:[CMRDataService shared].site_id forKey:@"site_id"];
            if(![[CMRDataService shared].recordModel isKindOfClass:[NSNull class]]){
                [defaults setObject:[CMRDataService shared].recordModel forKey:@"record"];
            }
            if (![[CMRDataService shared].remindModel isKindOfClass:[NSNull class]]) {
                [defaults setObject:[CMRDataService shared].remindModel forKey:@"remind"];
            }
            [defaults setObject:[NSString stringWithFormat:@"%d",[CMRDataService shared].flag] forKey:@"flag"];
            
            [defaults setObject:[NSString stringWithFormat:@"%d",[CMRDataService shared].jurisdiction] forKey:@"site_auth"];
            if (![[CMRDataService shared].strat_time isKindOfClass:[NSNull class]]) {
                [defaults setObject:[CMRDataService shared].strat_time forKey:@"strat_time"];
            }
            if (![[CMRDataService shared].end_time isKindOfClass:[NSNull class]]) {
                [defaults setObject:[CMRDataService shared].end_time forKey:@"end_time"];
            }
            if ([CMRDataService shared].tag_array.count>0) {
                [defaults setObject:[CMRDataService shared].tag_array forKey:@"tags"];
            }
            [defaults synchronize];
            //通讯录
            [CMRDataService shared].contactList = [[NSMutableArray alloc]init];
            NSArray *array_contact = [result objectForKey:@"person_list"];
            for (int i=0; i<array_contact.count; i++) {
                NSDictionary *dic = [array_contact objectAtIndex:i];
                ContactObject *contact = [ContactObject userFromDictionary:dic];
                [[CMRDataService shared].contactList addObject:contact];
            }
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
            [[AppDelegate shareIntance] showRootView];
            //////////////////////////////////////////////////////////////////////////////
//            UINavigationController *navControl1=nil;
//            UINavigationController *navControl2=nil;
//            if (iPhone5) {
//                //对话
//                CMRMessageViewController *messageView = [[CMRMessageViewController alloc]initWithNibName:@"CMRMessageViewController" bundle:nil];
//                navControl1 = [[UINavigationController alloc]initWithRootViewController:messageView];
//                //通讯录
//                CMRContactViewController *contactView = [[CMRContactViewController alloc]initWithNibName:@"CMRContactViewController" bundle:nil];
//                navControl2 = [[UINavigationController alloc]initWithRootViewController:contactView];
//            }else {
//                //对话
//                CMRMessageViewController *messageView = [[CMRMessageViewController alloc]initWithNibName:@"CMRMessageViewController_iphone4" bundle:nil];
//                navControl1 = [[UINavigationController alloc]initWithRootViewController:messageView];
//                //通讯录
//                CMRContactViewController *contactView = [[CMRContactViewController alloc]initWithNibName:@"CMRContactViewController_iphone4" bundle:nil];
//                navControl2 = [[UINavigationController alloc]initWithRootViewController:contactView];
//            }
//            
//            appDel.tabControl = [[UITabBarController alloc]init];
//            appDel.tabControl.delegate = appDel;
//            appDel.tabControl.viewControllers = [[NSArray alloc]initWithObjects:navControl2,navControl1, nil];
//            appDel.tabControl.tabBar.backgroundImage = [UIImage imageNamed:@"tabBar"];
//            appDel.window.rootViewController = appDel.tabControl;
            
            int count = 0;
            for (int i=0; i<[CMRDataService shared].contactList.count; i++) {
                ContactObject *contact = [[CMRDataService shared].contactList objectAtIndex:i];
                if (contact.isNewMessage==1) {
                    count ++;
                }
            }
            CMRMessageViewController *vc = (CMRMessageViewController *)[appDel.tabControl.viewControllers objectAtIndex:1];
            if (count==0) {
                vc.tabBarItem.badgeValue = nil;
            }else {
                vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
            }
        });
    });
}
-(void)getLogInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
#pragma mark   ---------UITextFieldDelegate----------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击键盘return键搜索
    if ([textField isEqual:self.txtName]) {
        [self.txtName resignFirstResponder];
        [self.txtPwd becomeFirstResponder];
    }else {
        [self.txtPwd resignFirstResponder];
    }
    return YES;
}
@end
