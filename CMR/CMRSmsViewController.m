//
//  CMRSmsViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-16.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRSmsViewController.h"

@interface CMRSmsViewController ()

@end

@implementation CMRSmsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CMRDataService shared].keyBoardTag = 1;
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(id)sender{
    AppDelegate *appDel = [AppDelegate shareIntance];
    CGRect frame = appDel.window.rootViewController.view.frame;
    [UIView beginAnimations:nil context:nil];
    CGRect frame2 = self.view.frame;
    if (frame2.origin.y == (frame.size.height-64-44-frame2.size.height)/2) {
        frame2.origin.y -= 68;
    }
    self.view.frame = frame2;
    [UIView commitAnimations];
}

- (void)keyBoardWillHide:(id)sender{
    AppDelegate *appDel = [AppDelegate shareIntance];
    CGRect frame = appDel.window.rootViewController.view.frame;
    [UIView beginAnimations:nil context:nil];
    CGRect frame2 = self.view.frame;
    if (frame2.origin.y== ((frame.size.height-64-44-frame2.size.height)/2-68)) {
        frame2.origin.y = (frame.size.height-64-44-frame2.size.height)/2;
    }
    self.view.frame = frame2;
    [UIView commitAnimations];
}
#pragma mark   ---------button点击事件----------------
//返回
-(IBAction)cancelAction:(id)sender {
    self.isSuccess = NO;
    [self.smsText resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissSmsPopView:)]) {
        [self.delegate dismissSmsPopView:self];
    }
}
//确定
-(IBAction)sureAction:(id)sender {
    [self.smsText resignFirstResponder];
    if (self.smsText.text.length==0 || [self.smsText.text isEqualToString:@""]) {
        [Utils errorAlert:@"请编辑短信内容!"];
    }else {
        self.isSuccess = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissSmsPopView:)]) {
            [self.delegate dismissSmsPopView:self];
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
