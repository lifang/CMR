//
//  TextView.m
//  CMR
//
//  Created by comdosoft on 14-2-21.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "TextView.h"

@interface TextView ()

@end

@implementation TextView

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
    if (iPhone5) {
        self.view.frame = CGRectMake(0, 0, 320, 500);
    }else {
        self.view.frame = CGRectMake(0, 0, 320, 384);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark   ---------button点击事件----------------
//返回
-(IBAction)cancelAction:(id)sender {
    self.isSuccess = NO;
    [self.textView resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissTxtPopView:)]) {
        [self.delegate dismissTxtPopView:self];
    }
}
//确定
-(IBAction)sureAction:(id)sender {
    [self.textView resignFirstResponder];
    if (self.textView.text.length==0 || [self.textView.text isEqualToString:@""]) {
        [Utils errorAlert:@"请编辑内容!"];
    }else {
        self.isSuccess = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissTxtPopView:)]) {
            [self.delegate dismissTxtPopView:self];
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
@end
