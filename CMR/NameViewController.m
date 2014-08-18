//
//  NameViewController.m
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "NameViewController.h"
#import "ContactObject.h"
@interface NameViewController ()

@end

@implementation NameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
	[l_button setTitle:@"完成" forState:UIControlStateNormal];
    
	[l_button addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *l_barButtonItem_edit = [[UIBarButtonItem alloc] initWithCustomView:l_button];
    self.sureBtn = l_barButtonItem_edit;
    
    self.navigationItem.rightBarButtonItem = self.sureBtn;
}
- (void)sureBtnAction:(id)sender  {
    NSString *msgStr = @"";
    NSString *text = @"";
    if ([self.title isEqualToString:@"性别信息"]) {
        if (self.sexInteger == 0) {
            text = @"女";
        }else {
            text = @"男";
        }
    }else  {
        text = self.nameTxt.text;
        if ([self.title isEqualToString:@"电话信息"]) {
            NSString *regexCall = @"1[0-9]{10}";
            NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
            if ([predicateCall evaluateWithObject:self.nameTxt.text]) {
                [self.nameTxt resignFirstResponder];
            }else {
                [self.nameTxt becomeFirstResponder];
                msgStr = @"请输入准确的电话";
            }
        }else if ([self.title isEqualToString:@"年龄信息"]) {
            NSString *regexCall = @"[1-9]{2}";
            NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
            if ([predicateCall evaluateWithObject:self.nameTxt.text]) {
                [self.nameTxt resignFirstResponder];
            }else {
                [self.nameTxt becomeFirstResponder];
                msgStr = @"请输入准确的年龄";
            }
        }else {
            [self.nameTxt resignFirstResponder];
        }
    }
    
    if (msgStr.length == 0) {
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NameInterface *log = [[NameInterface alloc]init];
            self.nameInter = log;
            self.nameInter.delegate = self;
            [self.nameInter getNameInterfaceDelegateWithID:[NSString stringWithFormat:@"%@",self.person.localID] andName:text andType:self.d_label.text];
            log = nil;
        }
    }else {
        [Utils errorAlert:msgStr];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (platform>=7.0) {
        AppDelegate *appDel = [AppDelegate shareIntance];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.view.frame = CGRectMake(0, 0, 320, appDel.window.frame.size.height-64);
    }
    if (iPhone5) {
        self.nameTxt.frame = CGRectMake(40, 49, 240, 32);
        self.sexSelectedView.frame = CGRectMake(40, 49, 240, 32);
    }else {
        self.nameTxt.frame = CGRectMake(40, 64, 240, 32);
        self.sexSelectedView.frame = CGRectMake(40, 64, 240, 32);
    }
    
    [self.view addSubview:self.nameTxt];
    [self.view addSubview:self.sexSelectedView];
    
    [self.nameTxt.layer setCornerRadius:6];
    [self.nameTxt.layer setMasksToBounds:YES];
    [self.nameTxt setText:self.txyString];
    
    if ([self.title isEqualToString:@"性别信息"]) {
        self.sexSelectedView.hidden = NO;
        self.nameTxt.hidden = YES;
        if ([self.txyString isEqualToString:@"女"]) {
            self.sexInteger = 0;
        }else {
            self.sexInteger = 1;
        }
        
        //性别
        QRadioButton *rb1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"sex"];
        QRadioButton *rb2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"sex"];
        rb1.frame = CGRectMake(50,3,22,22);
        rb2.frame = CGRectMake(141,3,22,22);
        rb1.tag = 0;//女
        rb2.tag = 1;//男
        [self.sexSelectedView addSubview:rb1];
        [self.sexSelectedView addSubview:rb2];
        if (rb1.tag == self.sexInteger) {
            [rb1 setChecked:YES];
        }else {
            [rb2 setChecked:YES];
        }
    }else {
        self.sexSelectedView.hidden = YES;
        self.nameTxt.hidden = NO;
    }
    
    NSString *destription_str = [self.title substringWithRange:NSMakeRange(0, self.title.length-2)];
    self.d_label.text = destription_str;
    
    
    [self setUI];
    [self initBackBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.nameTxt];
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
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.sureBtn setEnabled:NO];
    if ([self.title isEqualToString:@"性别信息"]) {
    }else {
        [self.nameTxt becomeFirstResponder];
        
        CGSize size = self.nameTxt.contentSize;
        size.height -= 2;
        if ( size.height >= 168 ) {
            size.height = 168;
        }
        else if ( size.height <= 32 ) {
            size.height = 32;
        }
        if ( size.height != self.nameTxt.frame.size.height ) {
            CGFloat span = size.height - self.nameTxt.frame.size.height;
            CGRect frame = self.nameTxt.frame;
            frame.size.height += span;
            self.nameTxt.frame = frame;
        }
    }
}
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    if ([groupId isEqualToString:@"sex"]) {
        [self.sureBtn setEnabled:YES];
        self.sexInteger = radio.tag;
    }
}

-(void)textFieldChanged:(NSNotification *)sender {
    [CMRDataService shared].isEditing = YES;
    [self.sureBtn setEnabled:YES];
}
-(void)setPerson:(ContactObject *)person {
    _person = person;
}
-(void)setDetail_index:(NSIndexPath *)detail_index {
    _detail_index = detail_index;
}
-(void)setTxyString:(NSString *)txyString {
    _txyString = txyString;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getNameInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *aDic = [result objectForKey:@"person"];
            ContactObject *contact = [ContactObject userFromDictionary:aDic];
            
            for (int i = 0; i<[CMRDataService shared].temp_contact.count; i++) {
                ContactObject *contact2 = [[CMRDataService shared].temp_contact objectAtIndex:i];
                if ([contact.localID integerValue] == [contact2.localID integerValue]) {
                    [[CMRDataService shared].temp_contact replaceObjectAtIndex:i withObject:contact];
                    [CMRDataService shared].index_row = i;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}
-(void)getNameInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
- (void)textViewDidChange:(UITextView *)_textView {
    CGSize size = self.nameTxt.contentSize;
    size.height -= 2;
    if ( size.height >= 168 ) {
        size.height = 168;
    }
    else if ( size.height <= 32 ) {
        size.height = 32;
    }
    if ( size.height != self.nameTxt.frame.size.height ) {
        CGFloat span = size.height - self.nameTxt.frame.size.height;
        CGRect frame = self.nameTxt.frame;
        frame.size.height += span;
        self.nameTxt.frame = frame;
    }
}

@end
