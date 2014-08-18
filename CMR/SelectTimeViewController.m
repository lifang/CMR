//
//  SelectTimeViewController.m
//  CMR
//
//  Created by comdosoft on 14-2-19.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "SelectTimeViewController.h"

@interface SelectTimeViewController ()

@end
#define kPickerAnimationDuration 0.40
@implementation SelectTimeViewController

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
-(void)initTimePickView {
    self.timeView.frame = CGRectMake(0, self.view.frame.size.height, 320, 195);
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm"];
    [self.view addSubview:self.timeView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置时间";
    self.tag_first = 0;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm"];
    
    if (platform>=7.0) {
        AppDelegate *appDel = [AppDelegate shareIntance];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.view.frame = CGRectMake(0, 0, 320, appDel.window.frame.size.height-64);
    }
    [self initBackBtn];
    [self setUI];
//    [self initTimePickView];
    
    if (![[CMRDataService shared].strat_time isKindOfClass:[NSNull class]] && [CMRDataService shared].strat_time.length>0) {
        self.startTxt.text = [CMRDataService shared].strat_time;
    }
    if(![[CMRDataService shared].end_time isKindOfClass:[NSNull class]] && [CMRDataService shared].end_time.length>0) {
        self.endTxt.text = [CMRDataService shared].end_time;
    }
    if ([CMRDataService shared].flag==0) {
        [self.switchBtn setOn:NO animated:YES];
    }else {
        [self.switchBtn setOn:YES animated:YES];
    }
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)compareString {
    NSArray *end_array = [self.endTxt.text componentsSeparatedByString:@":"];
    int end1 = [[end_array objectAtIndex:0]intValue];
    NSArray *start_array = [self.startTxt.text componentsSeparatedByString:@":"];
    int start1 = [[start_array objectAtIndex:0]intValue];
    
    if (end1>start1) {
        return YES;
    }else if (end1==start1){
        int end2 = [[end_array objectAtIndex:1]intValue];
        int start2 = [[start_array objectAtIndex:1]intValue];
        if (end2>start2) {
            return YES;
        }else {
            return NO;
        }
    }else
        return NO;
}
- (void)sureBtnAction:(id)sender {
    self.sureBtn.enabled = NO;
    NSString *str = @"";
    if (self.startTxt.text.length==0) {
        str = @"请选择开始时间";
    }
    if (self.endTxt.text.length==0 && str.length==0) {
        str = @"请选择结束时间";
    }
    if (str.length==0) {
        BOOL isSuccess = [self compareString];
        if (!isSuccess) {
            str = @"请设置正确的时间";
        }
    }
    if (str.length>0) {
        [Utils errorAlert:str];
    }else {
        [self hiddenPicker];
        [CMRDataService shared].strat_time = [NSString stringWithFormat:@"%@",self.startTxt.text];
        [CMRDataService shared].end_time = [NSString stringWithFormat:@"%@",self.endTxt.text];
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            NSString *type = @"";
            NSInteger f_flag = [CMRDataService shared].flag;
            if (self.switchBtn.isOn) {
                type = @"1";
                [CMRDataService shared].flag=1;
            }else{
                type = @"0";
                [CMRDataService shared].flag=0;
            }
            if (f_flag != [CMRDataService shared].flag) {
                [CMRDataService shared].isEditing = YES;
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            TimeInterface *log = [[TimeInterface alloc]init];
            self.timeInter = log;
            self.timeInter.delegate = self;
            [self.timeInter getTimeInterfaceDelegateWithStart:self.startTxt.text andEnd:self.endTxt.text andType:type];
            log = nil;
        }
    }
}
static NSInteger tag = 0;
//- (IBAction)dateAction:(id)sender
//{
//	NSArray *subViews = [self.view subviews];
//    for (UIView *vv in subViews) {
//        if ([vv isKindOfClass:[UITextField class]]) {
//            UITextField *txt = (UITextField *)vv;
//            if (txt.tag == tag) {
//                txt.text = [self.dateFormatter stringFromDate:self.pickerView.date];
//            }
//        }
//    }
//}
-(void)showPickerView {
    CGRect startFrame = self.timeView.frame;
    CGRect endFrame = self.timeView.frame;
    startFrame.origin.y = self.view.frame.size.height;
    endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
    self.timeView.frame = startFrame;
    [self.view addSubview:self.timeView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    self.timeView.frame = endFrame;
    [UIView commitAnimations];
}
-(IBAction)showPicker:(id)sender  {
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    if (tag==0) {
        if (self.startTxt.text.length>0) {
            self.pickerView.date = [self.dateFormatter dateFromString:self.startTxt.text];
        }else {
            self.pickerView.date = [NSDate date];
        }
        if (self.tag_first == 0) {
            [self showPickerView];
            self.tag_first = 1;
        }
    }else {
        if (self.endTxt.text.length>0) {
            self.pickerView.date = [self.dateFormatter dateFromString:self.endTxt.text];
        }else {
            self.pickerView.date = [NSDate date];
        }
        
        if (self.tag_first == 0) {
            [self showPickerView];
            self.tag_first = 1;
        }
    }
}

-(IBAction)cancelAction:(id)sender {
    [self hiddenPicker];
}
-(IBAction)saveAction:(id)sender {
    NSArray *subViews = [self.view subviews];
    for (UIView *vv in subViews) {
        if ([vv isKindOfClass:[UITextField class]]) {
            UITextField *txt = (UITextField *)vv;
            if (txt.tag == tag) {
                txt.text = [self.dateFormatter stringFromDate:self.pickerView.date];
                [self hiddenPicker];
            }
        }
    }
}
-(void)hiddenPicker {
    CGRect pickerFrame = self.timeView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.timeView.frame = pickerFrame;
    [UIView commitAnimations];
    
    self.tag_first = 0;
}
- (void)slideDownDidStop
{
	[self.timeView removeFromSuperview];
}


-(void)getTimeInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils errorAlert:@"时间设置成功"];
            [CMRDataService shared].strat_time = self.startTxt.text;
            [CMRDataService shared].end_time = self.endTxt.text;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%d",[CMRDataService shared].flag] forKey:@"flag"];
            [defaults setObject:[CMRDataService shared].strat_time forKey:@"strat_time"];
            [defaults setObject:[CMRDataService shared].end_time forKey:@"end_time"];
            [defaults synchronize];
            self.sureBtn.enabled = YES;
        });
    });
}
-(void)getTimeInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
    self.sureBtn.enabled = YES;
}
@end
