//
//  CMRPersonCell.h
//  CMR
//
//  Created by comdosoft on 14-1-13.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactObject.h"
@interface CMRPersonCell : UITableViewCell

@property (nonatomic, strong) ContactObject *person;
@property (nonatomic, strong) UIImageView *recordImg,*messageImg;
@property (nonatomic, assign) BOOL isSearch;
@end
