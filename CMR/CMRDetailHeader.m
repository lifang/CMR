//
//  CMRDetailHeader.m
//  CMR
//
//  Created by comdosoft on 14-1-14.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRDetailHeader.h"

@implementation CMRDetailHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 30)];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.font =[UIFont systemFontOfSize:16];
        [self addSubview:self.nameLab];
        
        self.messageImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 10, 10)];
        [self addSubview:self.messageImg];
        
        self.recordImg = [[UIImageView alloc]initWithFrame:CGRectMake(250, 7, 30, 30)];
        [self addSubview:self.recordImg];

        self.coverBt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.coverBt.backgroundColor = [UIColor clearColor];
        self.coverBt.frame = frame;
        [self addSubview:self.coverBt];
        [self.coverBt addTarget:self action:@selector(cellSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)cellSelected{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailHeader:)]) {
        [self.delegate detailHeader:self];
    }
}
-(void)setPerson:(ContactObject *)person {
    _person = person;
    if (person.isNewMessage==1) {
        self.messageImg.image = [UIImage imageNamed:@"contact_message"];
    }else {
        self.messageImg.image=nil;
    }
    
    if (person.isMakeRemind==1) {
        self.recordImg.image = [UIImage imageNamed:@"contact_record"];
    }else {
        self.recordImg.image = nil;
    }
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
