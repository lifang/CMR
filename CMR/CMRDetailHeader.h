//
//  CMRDetailHeader.h
//  CMR
//
//  Created by comdosoft on 14-1-14.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactObject.h"

@protocol CMRDetailHeaderDelegate;

@interface CMRDetailHeader : UITableViewHeaderFooterView
@property (nonatomic, assign) id<CMRDetailHeaderDelegate>delegate;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *messageImg,*recordImg;
@property (nonatomic, strong) ContactObject *person;
@property (nonatomic, strong) UIButton *coverBt;
@property (nonatomic, strong) UIImageView *img;
@end


@protocol CMRDetailHeaderDelegate <NSObject>
-(void)detailHeader:(CMRDetailHeader*)header;
@end