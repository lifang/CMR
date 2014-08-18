//
//  CMRSendMessageViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"
#import "ContactObject.h"
#import "CMRSubButton.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "CMRSmsViewController.h"
#import "CMRRecordViewController.h"
#import "MessageInterface.h"
#import "SendMessageInterface.h"
#import "EditInterface.h"
#import "CMRMessageUserUnionObject.h"
#import "CMRMessageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import <sys/xattr.h>
#import "SendInterface.h"

@class CMRMessageViewController;

@interface CMRSendMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIFolderTableViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,CMRSmsDelegate,CMRRecordDelegate,MessageInterfaceDelegate,SendMessageInterfaceDelegate,EditInterfaceDelegate,MessageDelegate,ASIHTTPRequestDelegate,UITextViewDelegate,SendInterfaceeDelegate>

{
    NSString * path;
    CGFloat keyboardHeight;
}
@property (nonatomic, strong) SendInterface *sendInter;
@property (nonatomic, strong) EditInterface *editInterface;
@property (nonatomic, strong) SendMessageInterface *sendinterface;
@property (nonatomic, strong) MessageInterface *messageInterface;
@property (nonatomic, assign) int page;

@property (nonatomic, strong) CMRMessageViewController *messageView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIFolderTableView *msgRecordTable;
@property (nonatomic, strong) NSMutableArray *msgRecords;
@property (nonatomic, strong) IBOutlet UIView *inputBar;
@property (nonatomic, strong) UIImage *myHeadImage,*userHeadImage;//
@property (nonatomic, strong) ContactObject *chatPerson;
//记录tableView位置
@property (nonatomic, assign) BOOL firstTime;
@property (nonatomic, assign) int page_status;

@property (nonatomic, strong) CMRSmsViewController *smsView;
@property (nonatomic, strong) CMRRecordViewController *recordView;

@property (nonatomic, strong) NSIndexPath *idxPath;
//记录
-(void)subViewEditBtnAction:(CMRSubButton *)btn;
-(void)subViewDeleteBtnAction:(CMRSubButton *)btn;
//提醒
-(void)subViewEditRemindBtnAction:(CMRSubButton *)btn;
-(void)subViewDeleteRemindBtnAction:(CMRSubButton *)btn;


@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

@property (nonatomic, strong) ASINetworkQueue *asiQueue;
@property (nonatomic, strong) ASIHTTPRequest *asiHttpRequest;

@property (nonatomic, strong) IBOutlet UIView *customeBar;
//输入框
@property (nonatomic, strong) IBOutlet UIView *textBar;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *keyboardButton;
@property (nonatomic, strong) IBOutlet UIButton *hideenBtn;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@end
