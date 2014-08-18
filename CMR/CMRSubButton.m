//
//  CMRSubButton.m
//  CMR
//
//  Created by comdosoft on 14-1-14.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRSubButton.h"

@implementation CMRSubButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark   ---------变量设置----------------
-(void)setPerson:(ContactObject *)person {
    _person = person;
}
-(void)setMsg:(CMRMessageObject *)msg {
    _msg = msg;
}
-(void)setIndex:(NSIndexPath *)index {
    _index = index;
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
