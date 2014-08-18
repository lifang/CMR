//
//  CMRRecordViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-16.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPopupBackgroundView.h"
#import "CMRMessageObject.h"
#import "SendMessageInterface.h"
#import "EditInterface.h"
#import "TextView.h"
enum CMRType {
    CMRTypeRecord = 0,  //记录
    CMRTypeRemind = 1   //提醒
};
@protocol CMRRecordDelegate;
@interface CMRRecordViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SendMessageInterfaceDelegate,EditInterfaceDelegate,UIScrollViewDelegate,CMRTxtDelegate>

@property (nonatomic, strong) EditInterface *editInterface;
@property (nonatomic, strong) SendMessageInterface *sendinterface;

@property (nonatomic, assign) enum CMRType types;

@property (nonatomic, strong) IBOutlet UILabel *titleLab;

@property (nonatomic, assign) id<CMRRecordDelegate> delegate;

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) IBOutlet UIScrollView *inputView;
//模版
@property (nonatomic, strong) NSString *modelString;


@property (nonatomic, strong) IBOutlet UIView *timeView;
@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) IBOutlet UIView *productView;
@property (nonatomic, strong) IBOutlet UIPickerView *productPicker;
@property (nonatomic, strong) NSMutableArray *productList;


@property (nonatomic, strong) CMRMessageObject *aMessage;

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *rangeArray;

@property (nonatomic, strong) TextView *ttV ;

-(void)dealWithString:(NSString *)string;
@end

@protocol CMRRecordDelegate <NSObject>
@optional
- (void)dismissRecordPopView:(CMRRecordViewController *)cMRRecordViewController andMessage:(CMRMessageObject *)aMessage;
@end