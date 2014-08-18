//
//  AppDelegate.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabControl;
@property (nonatomic, strong) NSString *pushstr;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, assign) BOOL isLoging;//1:表示登录进去     0:直接进去
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isSecond;
+(AppDelegate *)shareIntance;

- (void)showRootView;
@property (nonatomic, assign) int viewFrom;//拉开来自通讯录  还是对话
@property (nonatomic, assign) int navFrom;
@property (nonatomic, assign) int popFrom;//判断短信   记录or提醒
@end
