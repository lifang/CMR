//
//  SetCellFooter.m
//  CMR
//
//  Created by comdosoft on 14-2-19.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "SetCellFooter.h"

@implementation SetCellFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 280, 20)];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.textColor = [UIColor grayColor];
        self.nameLab.font =[UIFont systemFontOfSize:12];
        self.nameLab.numberOfLines = 0;
        [self addSubview:self.nameLab];
        
        self.backgroundView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
