//
//  CMRSendMessageViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRSendMessageViewController.h"

#import "CMRMessageSubViewController.h"
#import "CMRMessageViewController.h"
#import "CMRContactViewController.h"
#import "amrFileCodec.h"
#include <sys/types.h>
@interface CMRSendMessageViewController ()

@end

@implementation CMRSendMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if (platform>=5.1) {//5.1的阻止备份
        
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            //NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }else if (platform>5.0 && platform<5.1){//5.0.1的阻止备份
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    return YES;
}


static CGFloat newheight = 0;
- (void)tableViewWillReloadData:(UITableView *)tableView {
    if (self.firstTime==NO) {
        [self.msgRecordTable setContentOffset:CGPointMake(0, newheight)];
    }
}
- (void)tableViewDidReloadData:(UITableView *)tableView {
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
- (void)tableViewInit {
    self.msgRecordTable = [[UIFolderTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    self.msgRecordTable.delegate = self;
    self.msgRecordTable.dataSource = self;
    self.msgRecordTable.folderDelegate = self;
	self.msgRecordTable.backgroundColor=[UIColor whiteColor];
    [self.msgRecordTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.msgRecordTable];
    
    if ([CMRDataService shared].jurisdiction == 1) {
        self.textView.frame = CGRectMake(46, 6, 228, 32);
        [self.textBar addSubview:self.textView];
        
        self.textBar.frame = CGRectMake(0, self.msgRecordTable.frame.origin.y+self.msgRecordTable.frame.size.height, 320, 44);
        [self.view addSubview:self.textBar];
        
        self.inputBar.frame = CGRectMake(0, self.msgRecordTable.frame.origin.y+self.msgRecordTable.frame.size.height+44, 320, 44);
        [self.view addSubview:self.inputBar];
    }else {
        self.customeBar.frame = CGRectMake(0, self.msgRecordTable.frame.origin.y+self.msgRecordTable.frame.size.height, 320, 44);
        [self.view addSubview:self.customeBar];
    }
}
#pragma mark   ---------lifeStyle----------------
-(CGFloat)getconWithMessage:(CMRMessageObject *)msg{
    CGFloat conHeight = 0;
    NSString *orgin=msg.messageContent;
    if ([msg.messageType intValue] == CMRMessageTypeRemind) {
        CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake((320-[CMRDataService shared].headSize*2-3*INSETS-60), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
        conHeight += 66+textSize.height;
    }else if([msg.messageType intValue] == CMRMessageTypeNote) {
        CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake((320-[CMRDataService shared].headSize*2-3*INSETS-60), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
        conHeight += 66+textSize.height;
    }else {
        CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-[CMRDataService shared].headSize*2-3*INSETS-60), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
        if (textSize.height-30<0.0000001){
            conHeight += 66;
        }else {
            conHeight += 40+textSize.height;
        }
    }
    return conHeight;
}
-(CGFloat)cellHeightWithMessage:(CMRMessageObject *)msg {
    CGFloat conHeight = 0;
    NSString *string = [NSString stringWithFormat:@"%@",msg.messageFrom];
    enum CMRMessageCellStyle style = [string isEqualToString:[CMRDataService shared].user_id]?CMRMessageCellStyleMe:CMRMessageCellStyleOther;
    switch (style) {
            case CMRMessageCellStyleMe:
            conHeight = [self getconWithMessage:msg];
            break;
            case CMRMessageCellStyleOther:
            if ([msg.mediaType intValue] == CMRmediaTypeText) {
                CGSize textSize=[msg.messageContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-[CMRDataService shared].headSize*2-3*INSETS-60), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
                if (textSize.height-30<0.0000001){
                    conHeight += 66;
                }else {
                    conHeight += 40+textSize.height;
                }
            }else if ([msg.mediaType intValue] == CMRmediaTypeImage) {
                conHeight = 140;
            }else {
                conHeight = 70;
            }
            break;
            default:
            break;
    }
    return conHeight;
}
-(void)setContentOfset {
    CGFloat conHeight = 0;
    for (CMRMessageObject *obj in self.msgRecords) {
        conHeight += [self cellHeightWithMessage:obj];
    }
    if (conHeight<self.msgRecordTable.frame.size.height) {
        
    }else {
        [self.msgRecordTable setContentSize:CGSizeMake(320, conHeight)];
        [self.msgRecordTable setContentOffset:CGPointMake(0, self.msgRecordTable.contentSize.height-self.msgRecordTable.frame.size.height)];
    }
}
-(void)initHeaderView {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    header.backgroundColor = [UIColor clearColor];
    self.activity.frame = CGRectMake(150, 5, 20, 20);
    [self.activity startAnimating];
    [header addSubview:self.activity];
    self.msgRecordTable.tableHeaderView = header;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [CMRDataService shared].chat_person_id = [self.chatPerson.localID intValue];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (platform>=7.0) {
        AppDelegate *appDel = [AppDelegate shareIntance];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.view.frame = CGRectMake(0, 0, 320, appDel.window.frame.size.height-64);
    }
    
    self.navigationItem.title=self.chatPerson.name;
    [self tableViewInit];
    [self initBackBtn];
    self.page = 1;
    [self setContentOfset];

    
    self.firstTime = YES;
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.recordView = [[CMRRecordViewController alloc]initWithNibName:@"CMRRecordViewController" bundle:nil];
    self.recordView.delegate = self;
    self.useBlurForPopup = YES;
    //输入
    [self.textView.layer setCornerRadius:6];
    [self.textView.layer setMasksToBounds:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCList:) name:@"reloadCList" object:nil];
    
    [CMRDataService shared].keyBoardTag = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)reloadCList:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    if ([[dic objectForKey:@"sound"] intValue] == [self.chatPerson.localID intValue]) {
        [CMRDataService shared].isChating = YES;
        NSString *str2 = @"";
        NSString *str = [dic objectForKey:@"alert"];
        NSRange range_sub = [str rangeOfString:@":"];
        if (range_sub.location != NSNotFound) {
            str2 = [str substringWithRange:NSMakeRange(range_sub.location+range_sub.length, str.length-range_sub.location-range_sub.length)];
        }
        NSString *time = [Utils getNowDateFromatAnDate];
        NSDictionary *m_dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",kMESSAGE_ID,[NSString stringWithFormat:@"%@",self.chatPerson.localID],kMESSAGE_FROM,[CMRDataService shared].user_id,kMESSAGE_TO,str2,kMESSAGE_CONTENT,time,kMESSAGE_DATE,@"",kMESSAGE_TYPE, nil];
        CMRMessageObject *message = [CMRMessageObject messageFromDictionary:m_dic];
        [self.msgRecords addObject:message];
        [self.msgRecordTable reloadData];
        self.firstTime = YES;
        [self setContentOfset];
    }
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [CMRDataService shared].chat_person_id = -1;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   ---------初始化变量----------------
-(NSMutableArray *)msgRecords {
    if (!_msgRecords) {
        _msgRecords = [[NSMutableArray alloc]init];
    }
    return _msgRecords;
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgRecords.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier= @"chatCell";
    CMRMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[CMRMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    CMRMessageObject *msg=[self.msgRecords objectAtIndex:indexPath.row];
    [cell setMessageObject:msg];
    NSString *string = [NSString stringWithFormat:@"%@",msg.messageFrom];
    enum CMRMessageCellStyle style = [string isEqualToString:[CMRDataService shared].user_id]?CMRMessageCellStyleMe:CMRMessageCellStyleOther;
    
    switch (style) {
        case CMRMessageCellStyleMe:
            [cell setHeadImage:[CMRDataService shared].user_head];
            //判断消息类型
            if ([msg.messageType intValue]==CMRMessageTypePhone) {
                [cell setChatImage:[UIImage imageNamed:@"phoneImg"]];
            }else if([msg.messageType intValue]==CMRMessageTypeSms){
                [cell setChatImage:[UIImage imageNamed:@"smsImg"]];
            }else if ([msg.messageType intValue]==CMRMessageTypeNote){
                [cell setChatImage:[UIImage imageNamed:@"recordImg"]];
            }else if([msg.messageType intValue]==CMRMessageTypeRemind){
                [cell setChatImage:[UIImage imageNamed:@"remindImg"]];
            }else{
                [cell setChatImage:[UIImage imageNamed:@"weixin"]];
            }
            break;
        case CMRMessageCellStyleOther:
            [cell setHeadImage:self.chatPerson.userHead];
            if ([msg.mediaType intValue]==CMRmediaTypeText) {
                
            }else if ([msg.mediaType intValue]==CMRmediaTypeImage) {
                [cell getImageWithStr:msg.path];
            }else {
                cell.delegate = self;
                cell.voiceBtn.msg = msg;
            }
            
            break;
        default:
            break;
    }
    [cell setMsgStyle:style];
    
    return cell;
}
-(void)playVoiceWith:(CMRSubButton *)btn {
    NSString *pathString = btn.msg.path;
    NSArray *array = [pathString componentsSeparatedByString:@"/"];
    NSString *str = [array objectAtIndex:array.count-1];
    NSArray *arr = [str componentsSeparatedByString:@"."];
    NSString *nameStr = [arr objectAtIndex:0];//文件名
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.wav", docDirPath ,nameStr];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    if (fileExists) {
        self.musicPlayer = nil;
        self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
        self.musicPlayer.volume = 1;
        [self.musicPlayer play];
    }else {
        [self startButtonWithPath:btn andName:nameStr];
    }
    
    
//
    
    
//    NSURL *url = nil;
//    if (fileExists) {
//        url = [[NSURL alloc]initFileURLWithPath:[NSString stringWithFormat:@"%@",filePath]];
//    }else {
//        NSData * audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://116.255.202.113:3002%@",btn.msg.path]]];
//        
//        [audioData writeToFile:filePath atomically:YES];
//        url = [NSURL fileURLWithPath:filePath];
//    }
//    NSString *str = [[NSBundle mainBundle] pathForResource:@"5981267444833755211" ofType:@"amr"];
//    AVAudioPlayer *musicPlayerQiu = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:str] error:&error];
////    musicPlayerQiu.numberOfLoops=-1;//无限循环
//    self.musicPlayer=musicPlayerQiu;
//    musicPlayerQiu = nil;
//    self.musicPlayer.volume = 1;
//    [self.musicPlayer play];
}
-(void)startButtonWithPath:(CMRSubButton *)btn andName:(NSString *)name{
    NSString *pathStr = btn.msg.path;
    pathStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (CFStringRef)pathStr,
                                                                    NULL,
                                                                    NULL,
                                                                    kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://116.255.202.113:3002%@",pathStr]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.asiHttpRequest = [ASIHTTPRequest requestWithURL:url];
    self.asiHttpRequest.delegate = self;
    self.asiHttpRequest.downloadProgressDelegate=self;//下载进度的代理，用于断点续传
    NSString *nameString = [name stringByAppendingString:@".amr"];
    path = NSHomeDirectory();//该方法得到的是应用程序目录的路径
    //目的路径，设置一个目的路径用来存储下载下来的文件
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths    objectAtIndex:0];
    NSString *savePath=[documentsDirectory stringByAppendingPathComponent:nameString];
    
    //设置一个临时路径用来存储下载过程中的文件
    NSString *temp = [documentsDirectory stringByAppendingPathComponent:@"temp"];
    NSString *tempPath = [temp stringByAppendingPathComponent:nameString];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:temp];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:temp
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    if ([self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:documentsDirectory]]) {
        [self.asiHttpRequest setDownloadDestinationPath:savePath ];//下载路径
    }
    [self.asiHttpRequest setTemporaryFileDownloadPath:tempPath ];//临时路径，一定要设置临时路径。。
    
    _asiHttpRequest.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
    
    __block CMRSendMessageViewController *vv = self;
    [self.asiHttpRequest setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:vv.view animated:YES];
        NSString *fromStr = [NSString stringWithFormat:@"%@.amr",name];
        const char* from = [fromStr UTF8String];
        NSString *toStr = [NSString stringWithFormat:@"%@.wav",name];
        const char* to = [toStr UTF8String];
        int res = DecodeAMRFileToWAVEFile(from, to);
        if (res!=0) {
            NSString *ppath=[documentsDirectory stringByAppendingPathComponent:fromStr];
            [fileManager removeItemAtPath:ppath error:nil];
            [vv playVoiceWith:btn];
        }
    }];
    [self.asiHttpRequest setBytesReceivedBlock:^(unsigned long long size, unsigned long long total){           NSLog(@"size:%lld,total:%lld",size,total);
       
    }];
    [self.asiHttpRequest startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMRMessageObject *msg=[self.msgRecords objectAtIndex:indexPath.row];
    return [self cellHeightWithMessage:msg];
}
-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMRMessageObject *msg=[self.msgRecords objectAtIndex:indexPath.row];
    CGFloat height = [self cellHeightWithMessage:msg];
    return height/2;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMRMessageObject *msg=[self.msgRecords objectAtIndex:indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",msg.messageFrom];
    enum CMRMessageCellStyle style = [string isEqualToString:[CMRDataService shared].user_id]?CMRMessageCellStyleMe:CMRMessageCellStyleOther;
    if (style == CMRMessageCellStyleMe ) {
        if ([msg.messageType intValue]==CMRMessageTypeNote || [msg.messageType intValue]==CMRMessageTypeRemind) {
            if ([msg.messageStatus intValue]==0) {
                AppDelegate *appDel = [AppDelegate shareIntance];
                appDel.viewFrom = 1;
                //拉开的子view
                CMRMessageSubViewController *subView = [[CMRMessageSubViewController alloc]initWithNibName:@"CMRMessageSubViewController" bundle:nil];
                subView.sendMessageView = self;
                subView.aMessage = msg;
                subView.aIndex = indexPath;
                UIFolderTableView *folderTableView = (UIFolderTableView *)self.msgRecordTable;
                folderTableView.scrollEnabled= NO;
                [folderTableView openFolderAtIndexPath:indexPath WithContentView:subView.view
                                             openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             }
                                            closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            }
                                       completionBlock:^{
                                           folderTableView.scrollEnabled=YES;
                                       }];
            }
        }
    }
}
-(void)initData {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        self.page += 1;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MessageInterface *log = [[MessageInterface alloc]init];
        self.messageInterface = log;
        self.messageInterface.delegate = self;
        [self.messageInterface getMessageInterfaceDelegateWithID:[NSString stringWithFormat:@"%@",self.chatPerson.localID] andPage:[NSString stringWithFormat:@"%d",self.page]];
        log = nil;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.msgRecordTable])
    {
    if (self.page_status == 1) {
        if (scrollView.contentOffset.y <= 0) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self initHeaderView];
            [self initData];
        }
    }else
        self.msgRecordTable.tableHeaderView = nil;
    }
}
#pragma mark   ---------button点击事件----------------
//修改记录
-(void)subViewEditBtnAction:(CMRSubButton *)btn {
    DLog(@"修改记录");
    UIFolderTableView *folderTableView = (UIFolderTableView *)self.msgRecordTable;
    [folderTableView closeTheDoor];
    AppDelegate *appDel = [AppDelegate shareIntance];
    appDel.popFrom = 1;
    self.recordView.types = CMRTypeRecord;
    self.recordView.isEditing = YES;
    self.recordView.modelString = [NSString stringWithFormat:@"%@",btn.msg.messageContent];
    self.idxPath = btn.index;
    self.recordView.to_user_id = [NSString stringWithFormat:@"%d",[self.chatPerson.localID intValue]];
    [self.recordView setAMessage:btn.msg];
    
    [self presentPopupViewController:self.recordView animated:YES completion:^(void) {
    }];
}
//删除记录
-(void)subViewDeleteBtnAction:(CMRSubButton *)btn {
    DLog(@"删除记录");
    UIFolderTableView *folderTableView = (UIFolderTableView *)self.msgRecordTable;
    [folderTableView closeTheDoor];
    self.idxPath = btn.index;
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        EditInterface *log = [[EditInterface alloc]init];
        self.editInterface = log;
        self.editInterface.delegate = self;
        [self.editInterface getEditInterfaceDelegateWithMessageId:[NSString stringWithFormat:@"%d",[btn.msg.messageId intValue]] andContent:@"" andType:1];
        log = nil;
    }
}
//修改提醒
-(void)subViewEditRemindBtnAction:(CMRSubButton *)btn {
    DLog(@"修改提醒");
    UIFolderTableView *folderTableView = (UIFolderTableView *)self.msgRecordTable;
    [folderTableView closeTheDoor];
    AppDelegate *appDel = [AppDelegate shareIntance];
    appDel.popFrom = 1;
    self.recordView.types = CMRTypeRemind;
    self.recordView.isEditing = YES;
    self.recordView.modelString = [NSString stringWithFormat:@"%@",btn.msg.messageContent];
    self.idxPath = btn.index;
    self.recordView.to_user_id = [NSString stringWithFormat:@"%d",[self.chatPerson.localID intValue]];
    [self.recordView setAMessage:btn.msg];
    [self presentPopupViewController:self.recordView animated:YES completion:^(void) {
    }];
}
//删除提醒
-(void)subViewDeleteRemindBtnAction:(CMRSubButton *)btn {
    DLog(@"删除提醒");
    UIFolderTableView *folderTableView = (UIFolderTableView *)self.msgRecordTable;
    [folderTableView closeTheDoor];
    self.idxPath = btn.index;
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        EditInterface *log = [[EditInterface alloc]init];
        self.editInterface = log;
        self.editInterface.delegate = self;
        [self.editInterface getEditInterfaceDelegateWithMessageId:[NSString stringWithFormat:@"%d",[btn.msg.messageId intValue]] andContent:@"" andType:1];
        log = nil;
    }
}


//打电话
-(IBAction)phoneAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[self.chatPerson.phoneArray objectAtIndex:0] message:@"确定拨打电话?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
//发短信
-(IBAction)smsAction:(id)sender {
    AppDelegate *appDel = [AppDelegate shareIntance];
    appDel.popFrom = 0;
    self.smsView = nil;
    self.smsView = [[CMRSmsViewController alloc]initWithNibName:@"CMRSmsViewController" bundle:nil];
    self.smsView.delegate = self;
    [self presentPopupViewController:self.smsView animated:YES completion:^(void) {
    }];
}
//做记录
-(IBAction)recordAction:(id)sender {
    if ([[CMRDataService shared].recordModel isKindOfClass:[NSNull class]] || [CMRDataService shared].recordModel.length==0) {
        [Utils errorAlert:@"暂未建立记录模版"];
    }else {
        AppDelegate *appDel = [AppDelegate shareIntance];
        appDel.popFrom = 1;
        self.recordView.types = CMRTypeRecord;
        self.recordView.isEditing = NO;
        self.recordView.to_user_id = [NSString stringWithFormat:@"%d",[self.chatPerson.localID intValue]];
        self.recordView.modelString = [NSString stringWithFormat:@"%@",[CMRDataService shared].recordModel];
        [self presentPopupViewController:self.recordView animated:YES completion:^(void) {
        }];
    }
}
//提醒
-(IBAction)remindAction:(id)sender {
    if ([[CMRDataService shared].remindModel isKindOfClass:[NSNull class]] || [CMRDataService shared].remindModel.length==0) {
        [Utils errorAlert:@"暂未建立提醒模版"];
    }else {
        AppDelegate *appDel = [AppDelegate shareIntance];
        appDel.popFrom = 1;
        self.recordView.types = CMRTypeRemind;
        self.recordView.isEditing = NO;
        self.recordView.modelString = [NSString stringWithFormat:@"%@",[CMRDataService shared].remindModel];
        self.recordView.to_user_id = [NSString stringWithFormat:@"%d",[self.chatPerson.localID intValue]];
        [self presentPopupViewController:self.recordView animated:YES completion:^(void) {
        }];
    }
}

-(void)reloadContactList:(CMRMessageUserUnionObject *)unionObject {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRecentContactList" object:unionObject];
}
//发消息
-(IBAction)showInputView:(id)sender {
    [self.textView resignFirstResponder];
    CGRect frame = self.textBar.frame;
    [UIView animateWithDuration:0.25 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.msgRecordTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-44);
        self.textBar.frame = CGRectMake(0, self.msgRecordTable.frame.origin.y+self.msgRecordTable.frame.size.height+self.textBar.frame.size.height, 320, frame.size.height);
        
        self.inputBar.frame = CGRectMake(0, self.msgRecordTable.frame.origin.y+self.msgRecordTable.frame.size.height, 320, 44);
        
        [self scrollToBottomAnimated:YES];
        
    }
                     completion:nil];
    
}
//自定义类型
-(IBAction)showKeyBoardView:(id)sender {
    if ([CMRDataService shared].jurisdiction == 1) {
        CGRect frame = self.textBar.frame;
        [UIView animateWithDuration:0.25 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.msgRecordTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-frame.size.height);
            self.textBar.frame = CGRectMake(0, self.msgRecordTable.frame.origin.y+self.msgRecordTable.frame.size.height, 320, frame.size.height);
            self.inputBar.frame = CGRectMake(0, self.view.frame.size.height, 320, 44);
            [self scrollToBottomAnimated:YES];
        }
                         completion:nil];
    }
}

-(IBAction)hiddenKeyBoard:(id)sender {
    [self.textView resignFirstResponder];
}
#pragma mark   ---------短信协议----------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent) {
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SendMessageInterface *log = [[SendMessageInterface alloc]init];
            self.sendinterface = log;
            self.sendinterface.delegate = self;
            [self.sendinterface getSendMessageInterfaceDelegateWithTo_userId:[NSString stringWithFormat:@"%d",[self.chatPerson.localID intValue]] andContent:controller.body andType:[NSString stringWithFormat:@"%d",1]];
            log = nil;
        }
    }
    else
        NSLog(@"Message failed");
}
#pragma mark   ---------UIAlertView协议----------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        NSString *telStr = [NSString stringWithFormat:@"tel:%@",[self.chatPerson.phoneArray objectAtIndex:0]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];

        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SendMessageInterface *log = [[SendMessageInterface alloc]init];
            self.sendinterface = log;
            self.sendinterface.delegate = self;
            [self.sendinterface getSendMessageInterfaceDelegateWithTo_userId:[NSString stringWithFormat:@"%d",[self.chatPerson.localID intValue]] andContent:@"与客户通话" andType:[NSString stringWithFormat:@"%d",0]];
            log = nil;
        }
    }
}
#pragma mark   ---------CMRSmsDelegate协议----------------
-(void)dismissSmsPopView:(CMRSmsViewController *)cMRSmsViewController {
    [self dismissPopupViewControllerAnimated:YES completion:^{
        [CMRDataService shared].keyBoardTag = 0;
        if (cMRSmsViewController.isSuccess == YES) {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = cMRSmsViewController.smsText.text;
                controller.recipients = self.chatPerson.phoneArray;
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
        self.smsView = nil;
    }];
}
#pragma mark   ---------CMRRecordDelegate协议----------------

-(void)reloadMsgArrWith:(CMRMessageObject *)message {//刷新对应的cell
    [self.msgRecords replaceObjectAtIndex:self.idxPath.row withObject:message];
    [self.msgRecordTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)dismissRecordPopView:(CMRRecordViewController *)cMRRecordViewController andMessage:(CMRMessageObject *)aMessage{
    [CMRDataService shared].keyBoardTag = 0;
    [self dismissPopupViewControllerAnimated:YES completion:^{
        if (cMRRecordViewController.isSuccess == YES) {
            if (cMRRecordViewController.isEditing == YES) {
                [self reloadMsgArrWith:aMessage];
            }else {
                if ([aMessage.messageType intValue]==CMRMessageTypeRemind) {
                    [self reloadRemidWithStr:@"1"];
                }
                [self.msgRecords addObject:aMessage];
                [self.msgRecordTable reloadData];
                self.firstTime = YES;
                [self setContentOfset];
            }
            CMRMessageUserUnionObject *unionObject = [CMRMessageUserUnionObject unionWithMessage:aMessage andUser:self.chatPerson];
            [self reloadContactList:unionObject];
        }
    }];
}
#pragma mark   ---------MessageInterfaceDelegate----------------
-(void)getMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.msgRecordTable.tableHeaderView = nil;
            self.page_status = [[result objectForKey:@"page_status"]intValue];
            self.firstTime = NO;
            NSMutableArray *arrayRecords = self.msgRecords;
            self.msgRecords = nil;
            //消息
            NSArray *array = [result objectForKey:@"message_list"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                CMRMessageObject *message = [CMRMessageObject messageFromDictionary:dic];
                [self.msgRecords addObject:message];
            }
            NSMutableArray *tmpArr = self.msgRecords;
            CGFloat newHeight = 0;
            for (CMRMessageObject *obj in tmpArr) {
                newHeight += [self cellHeightWithMessage:obj];
            }
            newheight = newHeight;
            [self.msgRecords addObjectsFromArray:arrayRecords];
            [self.msgRecordTable reloadData];
        });
    });
}
-(void)getMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.msgRecordTable.tableHeaderView = nil;
    [Utils errorAlert:errorMsg];
}
#pragma mark   ---------SendMessageInterfaceDelegate----------------
-(void)getSendMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dic = [result objectForKey:@"message"];
            CMRMessageObject *msg = [CMRMessageObject messageFromDictionary:dic];
            [self.msgRecords addObject:msg];
            [self.msgRecordTable reloadData];
            self.firstTime = YES;
            [self setContentOfset];
            CMRMessageUserUnionObject *unionObject = [CMRMessageUserUnionObject unionWithMessage:msg andUser:self.chatPerson];
            [self reloadContactList:unionObject];
        });
    });
}
-(void)getSendMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
#pragma mark   ---------EditInterfaceDelegate----------------
-(void)deleteMsg {
    [self.msgRecords removeObjectAtIndex:self.idxPath.row];
    [self.msgRecordTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:self.idxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)reloadRemidWithStr:(NSString *)str {
    if ([str intValue]==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByChatDelete" object:self.chatPerson];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByChatAdd" object:self.chatPerson];
    }
     
}
-(void)getEditInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self deleteMsg];
            if (![[result objectForKey:@"last_message"]isKindOfClass:[NSNull class]] && [result objectForKey:@"last_message"]!=nil) {
                NSDictionary *dic = [result objectForKey:@"last_message"];
                CMRMessageObject *msg = [CMRMessageObject messageFromDictionary:dic];
                CMRMessageUserUnionObject *unionObject = [CMRMessageUserUnionObject unionWithMessage:msg andUser:self.chatPerson];
                [self reloadContactList:unionObject];
            }else {
                CMRMessageObject *msg = [[CMRMessageObject alloc]init];
                CMRMessageUserUnionObject *unionObject = [CMRMessageUserUnionObject unionWithMessage:msg andUser:self.chatPerson];
                [self reloadContactList:unionObject];
            }
            
            
            NSString *type = [result objectForKey:@"type"];
            if ([type intValue] == 3) {//删除提醒
                NSString *has_remind = [result objectForKey:@"has_remind"];
                if ([has_remind intValue] == 1) {
                    
                }else {//刷新数据
                    [self reloadRemidWithStr:has_remind];
                }
            }
        });
    });
}
-(void)getEditInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}


- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.msgRecordTable numberOfRowsInSection:0];
    if(rows > 0) {
        [self.msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}
#pragma mark - Keyboard notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    if ([CMRDataService shared].keyBoardTag == 0) {
        NSDictionary *userInfo = [notification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect = [aValue CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             CGRect frame = self.msgRecordTable.frame;
                             frame.size.height += keyboardHeight;
                             frame.size.height -= keyboardRect.size.height;
                             self.msgRecordTable.frame = frame;
                             
                             frame = self.textBar.frame;
                             frame.origin.y += keyboardHeight;
                             frame.origin.y -= keyboardRect.size.height;
                             self.textBar.frame = frame;
                             
                             keyboardHeight = keyboardRect.size.height;
                         }];
        if ( self.msgRecords.count ) {
            [self scrollToBottomAnimated:NO];
        }
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
    if ([CMRDataService shared].keyBoardTag == 0) {
        NSDictionary *userInfo = [notification userInfo];
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             CGRect frame = self.msgRecordTable.frame;
                             frame.size.height += keyboardHeight;
                             self.msgRecordTable.frame = frame;
                             
                             frame = self.textBar.frame;
                             frame.origin.y += keyboardHeight;
                             self.textBar.frame = frame;
                             
                             keyboardHeight = 0;
                         }];
    }
}


#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)_textView {
    CGSize size = self.textView.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        size.height = 32;
    }
    if ( size.height != self.textView.frame.size.height ) {
        CGFloat span = size.height - self.textView.frame.size.height;
        CGRect frame = self.textBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        self.textBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        frame = self.textView.frame;
        frame.size = size;
        self.textView.frame = frame;
        
        frame = self.msgRecordTable.frame;
        frame.size.height -= span;
        self.msgRecordTable.frame = frame;
        if ( self.msgRecords.count ) {
            [self scrollToBottomAnimated:NO];
        }
        
        CGPoint center = self.textView.center;
        center.y = centerY;
        self.textView.center = center;
        
        center = self.keyboardButton.center;
        center.y = centerY;
        self.keyboardButton.center = center;
        
        center = self.hideenBtn.center;
        center.y = centerY;
        self.hideenBtn.center = center;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SendInterface *log = [[SendInterface alloc]init];
            self.sendInter = log;
            self.sendInter.delegate = self;
            [self.sendInter getSendInterfaceDelegateWithContent:self.textView.text andType:@"text" andId:[NSString stringWithFormat:@"%d",[self.chatPerson.localID intValue]]];
            log = nil;
        }
        
        return NO;
    }
    
    return YES;
}
#pragma mark   ---------SendInterfaceeDelegate----------------
-(void)getSendInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.msgRecordTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-44);
            self.textBar.frame = CGRectMake(0, self.msgRecordTable.frame.origin.y+self.msgRecordTable.frame.size.height, 320, 44);
            
            self.textView.text = nil;
            self.textView.frame = CGRectMake(46, 6, 228, 32);
            [self scrollToBottomAnimated:YES];
            
            CGFloat centerY = 22;
            CGPoint center = self.textView.center;
            center.y = centerY;
            self.textView.center = center;
            
            center = self.keyboardButton.center;
            center.y = centerY;
            self.keyboardButton.center = center;
            
            center = self.hideenBtn.center;
            center.y = centerY;
            self.hideenBtn.center = center;
            
            NSDictionary *dic = [result objectForKey:@"message"];
            CMRMessageObject *msg = [CMRMessageObject messageFromDictionary:dic];
            [self.msgRecords addObject:msg];
            [self.msgRecordTable reloadData];
            self.firstTime = YES;
            [self setContentOfset];
            CMRMessageUserUnionObject *unionObject = [CMRMessageUserUnionObject unionWithMessage:msg andUser:self.chatPerson];
            [self reloadContactList:unionObject];
        });
    });
}
-(void)getSendInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
@end
