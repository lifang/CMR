//
//  AppDelegate.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioServices.h>
#import "LogInViewController.h"
#import "CMRMessageViewController.h"
#import "CMRContactViewController.h"
@implementation AppDelegate

+(AppDelegate *)shareIntance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)showRootView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    if (user_id != nil) {
        self.isLoging = NO;
        self.isFirst = NO;
        self.isSecond = NO;
        [CMRDataService shared].user_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"user_id"]];
        [CMRDataService shared].site_id = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"site_id"]];
        
        if ([defaults objectForKey:@"record"]) {
            [CMRDataService shared].recordModel = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"record"]];//记录模版
        }
        if ([defaults objectForKey:@"remind"]) {
            [CMRDataService shared].remindModel = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"remind"]];//提醒模版
        }
        
        [CMRDataService shared].flag = [[defaults objectForKey:@"flag"]integerValue];
        [CMRDataService shared].jurisdiction = [[defaults objectForKey:@"site_auth"]integerValue];
        if ([defaults objectForKey:@"strat_time"]) {
             [CMRDataService shared].strat_time = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"strat_time"]];
        }
        if ([defaults objectForKey:@"end_time"]) {
            [CMRDataService shared].end_time = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"end_time"]];
        }
        
        [CMRDataService shared].tag_array = [NSMutableArray arrayWithArray:[defaults objectForKey:@"tags"]];
        [defaults setObject:@"1" forKey:@"isOn"];
        [defaults synchronize];
        
        if ([CMRDataService shared].jurisdiction == 1) {
            [CMRDataService shared].headSize = 40;
        }else {
            [CMRDataService shared].headSize = 0;
        }
        
        UINavigationController *navControl1=nil;
        UINavigationController *navControl2=nil;
        if (iPhone5) {
            //对话
            CMRMessageViewController *messageView = [[CMRMessageViewController alloc]initWithNibName:@"CMRMessageViewController" bundle:nil];
            navControl1 = [[UINavigationController alloc]initWithRootViewController:messageView];
            //通讯录
            CMRContactViewController *contactView = [[CMRContactViewController alloc]initWithNibName:@"CMRContactViewController" bundle:nil];
            navControl2 = [[UINavigationController alloc]initWithRootViewController:contactView];
        }else {
            //对话
            CMRMessageViewController *messageView = [[CMRMessageViewController alloc]initWithNibName:@"CMRMessageViewController_iphone4" bundle:nil];
            navControl1 = [[UINavigationController alloc]initWithRootViewController:messageView];
            //通讯录
            CMRContactViewController *contactView = [[CMRContactViewController alloc]initWithNibName:@"CMRContactViewController_iphone4" bundle:nil];
            navControl2 = [[UINavigationController alloc]initWithRootViewController:contactView];
        }
        
        self.tabControl = [[UITabBarController alloc]init];
        self.tabControl.viewControllers = [[NSArray alloc]initWithObjects:navControl2,navControl1, nil];
        self.tabControl.tabBar.backgroundImage = [UIImage imageNamed:@"tabBar"];
        self.window.rootViewController = self.tabControl;
    }else {
        self.isLoging = YES;
        self.isFirst = YES;
        self.isSecond = YES;
        //登录
        LogInViewController *logInView = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
        self.window.rootViewController = logInView;
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [CMRDataService shared].isChating = NO;
    [CMRDataService shared].host = @"http://demo.sunworldmedia.com/api";
//    [CMRDataService shared].host = @"http://192.168.0.35:3001/api";
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [self performSelectorOnMainThread:@selector(showRootView) withObject:nil waitUntilDone:NO];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        [[CMRDataService shared] run];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    CMRMessageViewController *vc = (CMRMessageViewController *)[self.tabControl.viewControllers objectAtIndex:1];
    int count = [vc.tabBarItem.badgeValue intValue];
    [UIApplication sharedApplication].applicationIconBadgeNumber = count;
    
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        [[CMRDataService shared] run];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[CMRDataService shared] stop];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"isOn"];
    [defaults synchronize];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString *deviceStr=[deviceToken description];
    
    NSString *tempStr1=[deviceStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    _pushstr=[tempStr2 stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    _pushstr=@"";
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
	if (badge != nil) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [badge intValue];
    }
    //接收到push  会震动
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isOn = [defaults objectForKey:@"isOn"];
    if ([isOn intValue] == 1) {//app登录
        NSString *uid = [apsInfo objectForKey:@"sound"];
        //最近联系人
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadList" object:apsInfo];
        //通讯录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByMessageAdd" object:uid];
        CMRMessageViewController *vc = (CMRMessageViewController *)[self.tabControl.viewControllers objectAtIndex:1];
        vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",badge];
    }
    
}

@end
