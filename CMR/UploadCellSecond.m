//
//  UploadCellSecond.m
//  ZQApp
//
//  Created by peng on 14-2-13.
//  Copyright (c) 2014年 QCX. All rights reserved.
//

#import "UploadCellSecond.h"

@implementation UploadCellSecond

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.switchBtn = [[UISwitch alloc]initWithFrame:CGRectZero];
        [self.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:self.switchBtn];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MessageListCellBkg"]];
    }
    return self;
}
-(void)switchAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setShieldBy:)]) {
        [self.delegate setShieldBy:self.switchBtn];
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.switchBtn.frame = CGRectMake(230, 6, 79, 27);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
