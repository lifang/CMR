//
//  CMRDetailCell.m
//  CMR
//
//  Created by comdosoft on 14-1-14.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRDetailCell.h"

@implementation CMRDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 24)];
        self.lab1.font = [UIFont systemFontOfSize:14];
        self.lab1.textColor = [UIColor grayColor];
        self.lab1.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lab1];
        
        self.lab2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 7, 210, 30)];
        self.lab2.font = [UIFont systemFontOfSize:16];
        self.lab2.textColor = [UIColor blackColor];
        self.lab2.numberOfLines = 0;
        self.lab2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lab2];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
