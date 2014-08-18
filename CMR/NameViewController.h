//
//  NameViewController.h
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameInterface.h"
#import "ContactObject.h"
#import "QRadioButton.h"

@interface NameViewController : UIViewController<NameInterfaceDelegate,UITextViewDelegate>

@property (nonatomic, strong) NameInterface *nameInter;
//@property (nonatomic, strong) IBOutlet UITextField *nameTxt;
@property (nonatomic, strong) ContactObject *person;
@property (nonatomic, strong) NSIndexPath *detail_index;
@property (nonatomic, strong) UIBarButtonItem *sureBtn;
@property (nonatomic, strong) IBOutlet UILabel *d_label;
@property (nonatomic, strong) NSString *txyString;

@property (nonatomic, assign) NSInteger sexInteger;
@property (strong, nonatomic) IBOutlet UIView *sexSelectedView;
@property (nonatomic, strong) IBOutlet UITextView *nameTxt;
@end
