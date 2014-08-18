//
//  UploadCellFirst.h
//  ZQApp
//
//  Created by peng on 14-2-13.
//  Copyright (c) 2014年 QCX. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactObject.h"
@interface UploadCellFirst : UITableViewCell
@property (nonatomic, strong) UILabel *nameLab;

-(void)setPersonObject:(ContactObject*)obj;
@end
