//
//  SetSecondCell.m
//  CMR
//
//  Created by comdosoft on 14-2-19.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "SetSecondCell.h"

@implementation SetSecondCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.textColor = [UIColor grayColor];
        self.nameLab.font = [UIFont systemFontOfSize:14];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.nameLab];
        
        if ([CMRDataService shared].flag==0) {
            self.nameLab.text = @"已关闭";
        }else
            self.nameLab.text = @"已开启";
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MessageListCellBkg"]];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.nameLab.frame = CGRectMake(130, 15, 166, 14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
