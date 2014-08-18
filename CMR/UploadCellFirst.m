//
//  UploadCellFirst.m
//  ZQApp
//
//  Created by peng on 14-2-13.
//  Copyright (c) 2014年 QCX. All rights reserved.
//

#import "UploadCellFirst.h"

@implementation UploadCellFirst

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
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MessageListCellBkg"]];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.nameLab.frame = CGRectMake(130, 15, 166, 14);
}

-(void)setPersonObject:(ContactObject*)obj {
    if (![obj.remark isKindOfClass:[NSNull class]] && obj.remark!=nil) {
        _nameLab.text = [NSString stringWithFormat:@"%@",obj.remark] ;
    }else
        _nameLab.text = obj.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
