//
//  CMRMessageSubViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-15.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRMessageSubViewController.h"
#import "CMRSendMessageViewController.h"
@interface CMRMessageSubViewController ()

@end

@implementation CMRMessageSubViewController

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
    
    if ([self.aMessage.messageType intValue]==CMRMessageTypeNote) {
//        CMRSubButton *editBtn = [CMRSubButton buttonWithType:UIButtonTypeCustom];
//        editBtn.frame = CGRectMake(10, 8, 140, 40);
//        editBtn.msg = self.aMessage;
//        editBtn.index = self.aIndex;
//        [editBtn setImage:[UIImage imageNamed:@"recordEditBtn"] forState:UIControlStateNormal];
//        [editBtn setImage:[UIImage imageNamed:@"recordEditBtnHL"] forState:UIControlStateHighlighted];
//        [editBtn addTarget:self.sendMessageView action:@selector(subViewEditBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:editBtn];
        
        
        CMRSubButton *deleteBtn = [CMRSubButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(60, 8, 200, 40);
        deleteBtn.msg = self.aMessage;
        deleteBtn.index = self.aIndex;
        [deleteBtn setImage:[UIImage imageNamed:@"recordDeleteBtn"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"recordDeleteBtnHL"] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self.sendMessageView action:@selector(subViewDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteBtn];
    }
    else if ([self.aMessage.messageType intValue]==CMRMessageTypeRemind) {
//        CMRSubButton *editBtn = [CMRSubButton buttonWithType:UIButtonTypeCustom];
//        editBtn.frame = CGRectMake(10, 8, 140, 40);
//        editBtn.msg = self.aMessage;
//        editBtn.index = self.aIndex;
//        [editBtn setTitle:@"修改此条提醒" forState:UIControlStateNormal];
//        [editBtn setImage:[UIImage imageNamed:@"remindEditBtn"] forState:UIControlStateNormal];
//        [editBtn setImage:[UIImage imageNamed:@"remindEditBtnHL"] forState:UIControlStateHighlighted];
//        [editBtn addTarget:self.sendMessageView action:@selector(subViewEditRemindBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:editBtn];
        
        
        CMRSubButton *deleteBtn = [CMRSubButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(60, 8, 200, 40);
        deleteBtn.msg = self.aMessage;
        deleteBtn.index = self.aIndex;
        [deleteBtn setTitle:@"删除此条提醒" forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"remindDeleteBtn"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"remindDeleteBtnHL"] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self.sendMessageView action:@selector(subViewDeleteRemindBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteBtn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
