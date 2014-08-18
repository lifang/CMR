//
//  CMRSubViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-13.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRSubViewController.h"
#import "CMRContactViewController.h"
@interface CMRSubViewController ()

@end

@implementation CMRSubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark   ---------lifeStyle----------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CMRSubButton *infoBtn = [CMRSubButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(10, 8, 140, 40);
    infoBtn.person = self.person;
    infoBtn.index = self.idxPath;
    [infoBtn setTitle:@"查看个人信息" forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"infoBtn"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"infoBtnHL"] forState:UIControlStateHighlighted];
    [infoBtn addTarget:self.contactView action:@selector(subViewInfoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoBtn];
    
    CMRSubButton *recordBtn = [CMRSubButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake(170, 8, 140, 40);
    recordBtn.person = self.person;
    recordBtn.index = self.idxPath;
    [recordBtn setTitle:@"进入往来记录" forState:UIControlStateNormal];
    [recordBtn setImage:[UIImage imageNamed:@"chatRecordBtn"] forState:UIControlStateNormal];
    [recordBtn setImage:[UIImage imageNamed:@"chatRecordBtnHL"] forState:UIControlStateHighlighted];
    [recordBtn addTarget:self.contactView action:@selector(subViewRecordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
