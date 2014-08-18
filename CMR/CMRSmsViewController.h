//
//  CMRSmsViewController.h
//  CMR
//
//  Created by comdosoft on 14-1-16.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CMRSmsDelegate;
@interface CMRSmsViewController : UIViewController<UITextViewDelegate>
@property (nonatomic,strong) IBOutlet UITextView *smsText;
@property (nonatomic, assign) id<CMRSmsDelegate> delegate;
@property (nonatomic, assign) BOOL isSuccess;
@end


@protocol CMRSmsDelegate <NSObject>
@optional
- (void)dismissSmsPopView:(CMRSmsViewController *)cMRSmsViewController;
@end