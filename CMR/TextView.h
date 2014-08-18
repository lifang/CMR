//
//  TextView.h
//  CMR
//
//  Created by comdosoft on 14-2-21.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMRTxtDelegate;
@interface TextView : UIViewController<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) id<CMRTxtDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIView *subview;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@end

@protocol CMRTxtDelegate <NSObject>
@optional
- (void)dismissTxtPopView:(TextView *)txtView;
@end