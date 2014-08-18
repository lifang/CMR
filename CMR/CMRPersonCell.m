//
//  CMRPersonCell.m
//  CMR
//
//  Created by comdosoft on 14-1-13.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRPersonCell.h"

@implementation CMRPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.messageImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
        [self.contentView addSubview:self.messageImg];
        
        self.recordImg = [[UIImageView alloc]initWithFrame:CGRectMake(250, 7, 30, 30)];
        [self.contentView addSubview:self.recordImg];
        
        UILabel *sLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, 320, 0.5)];
        sLine1.backgroundColor = [UIColor colorWithRed:198/255.0
                                                 green:198/255.0
                                                  blue:198/255.0
                                                 alpha:1.0];
        [self.contentView addSubview:sLine1];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews {
    [super layoutSubviews];
}
-(void)setPerson:(ContactObject *)person {
    _person = person;
    self.messageImg.hidden = self.isSearch;
    self.recordImg.hidden = self.isSearch;
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
@end
