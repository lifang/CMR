//
//  LogInViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-22.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInterface.h"
#import "ContactObject.h"
#import "CMRMessageObject.h"
#import "CMRMessageUserUnionObject.h"

@interface LogInViewController : UIViewController<UITextFieldDelegate,LogInterfaceDelegate>

@property (nonatomic, strong) LogInterface *logInterface;
@property (nonatomic, strong) IBOutlet UITextField *txtName;
@property (nonatomic, strong) IBOutlet UITextField *txtPwd;
@property (nonatomic, strong) IBOutlet UIView *loginView;
@end
