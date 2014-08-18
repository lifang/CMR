//
//  CMRRecentListCell.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRRecentListCell.h"

//间距
#define INSETS 4.0f

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation CMRRecentListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _userNickname=[[UILabel alloc]initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc]initWithFrame:CGRectZero];
        _timeLable=[[UILabel alloc]initWithFrame:CGRectZero];
        _cellBkg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MessageListCellBkg"]];
        _bageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contact_message"]];
        _bageNumber=[[UILabel alloc]initWithFrame:CGRectZero];

        [_userHead.layer setCornerRadius:8.0f];
        [_userHead.layer setMasksToBounds:YES];
        
        [_userNickname setFont:[UIFont boldSystemFontOfSize:15]];
        [_userNickname setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:13]];
        [_messageConent setTextColor:[UIColor lightGrayColor]];
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        
        [_timeLable setTextColor:[UIColor lightGrayColor]];
        [_timeLable setFont:[UIFont systemFontOfSize:12]];
        [_timeLable setBackgroundColor:[UIColor clearColor]];
        
        [_bageNumber setBackgroundColor:[UIColor clearColor]];
        [_bageNumber setTextAlignment:NSTextAlignmentCenter];
        [_bageNumber setTextColor:[UIColor whiteColor]];
        [_bageNumber setFont:[UIFont boldSystemFontOfSize:12]];

        [self setBackgroundView:_cellBkg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_userNickname];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_timeLable];
        [self.contentView addSubview:_bageView];
        [_bageView addSubview:_bageNumber];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    
    [_userHead setFrame:CGRectMake(INSETS, (CELL_HEIGHT-[CMRDataService shared].headSize)/2,[CMRDataService shared].headSize , [CMRDataService shared].headSize)];
    [_userNickname setFrame:CGRectMake(2*INSETS+[CMRDataService shared].headSize, INSETS, (CELL_WIDTH-[CMRDataService shared].headSize-INSETS*3), 20)];
    [_messageConent setFrame:CGRectMake(2*INSETS+[CMRDataService shared].headSize, INSETS+_userNickname.frame.size.height, (CELL_WIDTH-[CMRDataService shared].headSize-INSETS*3), 20)];
    [_timeLable setFrame:CGRectMake(CELL_WIDTH-110, INSETS, 180, (CELL_HEIGHT-3*INSETS)/2)];

    [_bageNumber setFrame:CGRectMake(0,0, 25, 25)];
    [_bageView setFrame:CGRectMake(5, 5, 10, 10)];
    _cellBkg.frame=self.contentView.frame;
}

-(void)setUnionObject:(CMRMessageUserUnionObject*)aUnionObj
{
    [_userNickname setText:aUnionObj.user.name];
    NSString *origin = aUnionObj.message.messageContent;
    if (![origin isKindOfClass:[NSNull class]] && origin.length>0) {
        [_messageConent setText:origin];
    }else {
        [_messageConent setText:@""];
    }
    
    [_timeLable setText:aUnionObj.message.messageDate];
    if ([CMRDataService shared].jurisdiction == 1) {
        [self setHeadImage:aUnionObj.user.userHead];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@",aUnionObj.message.messageFrom];
    enum CMRMessageCellStyle style = [string isEqualToString:[CMRDataService shared].user_id]?CMRMessageCellStyleMe:CMRMessageCellStyleOther;
    if (style == CMRMessageCellStyleMe ) {
        [_bageView setHidden:YES];
    }else {
        if ([aUnionObj.message.messageStatus intValue]==1) {
            [_bageView setHidden:NO];
        }else {
            [_bageView setHidden:YES];
        }
    }
}
-(void)setHeadImage:(NSString*)imageURL
{
    if (![imageURL isKindOfClass:[NSNull class]]) {
        NSURL *url = [NSURL URLWithString:imageURL];
        [_userHead setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserHeaderImageBox"]];
    }
}

@end
