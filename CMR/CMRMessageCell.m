//
//  CMRMessageCell.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRMessageCell.h"
#import "UIImageView+Addition.h"
#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width
#define TIME_HEIGHT 12
@implementation CMRMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _bubbleBg =[[UIImageView alloc]initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc]initWithFrame:CGRectZero];
        _headMask =[[UIImageView alloc]initWithFrame:CGRectZero];
        _chatImage =[[UIImageView alloc]initWithFrame:CGRectZero];
        _timeLab=[[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab=[[UILabel alloc]initWithFrame:CGRectZero];
        
        [_timeLab.layer setCornerRadius:3];
        [_timeLab.layer setMasksToBounds:YES];
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.backgroundColor = [UIColor lightGrayColor];
        _timeLab.font = [UIFont systemFontOfSize:10];
        _timeLab.frame = CGRectMake(110, INSETS, 100, TIME_HEIGHT);

        _titleLab.textColor = [UIColor blackColor];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.font = [UIFont systemFontOfSize:15];
        
        _voiceBtn = [CMRSubButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = CGRectZero;
        [_voiceBtn setImage:[UIImage imageNamed:@"remindImg"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setNumberOfLines:20];
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_voiceBtn];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_chatImage];
        [self.contentView addSubview:_timeLab];
        [self.contentView addSubview:_titleLab];

        
        [_chatImage setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    }
    return self;
}
-(void)play:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playVoiceWith:)]) {
        [self.delegate playVoiceWith:self.voiceBtn];
    }
}
-(NSString *)getContentfronMessage:(NSString *)string {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSString *regTags = @"\\[\\[.*?]]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    // 用下面的办法来遍历每一条匹配记录
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *tagString = [string substringWithRange:matchRange];  // 整个匹配串
        [tempArray addObject:tagString];
    }
    NSMutableString *contentString = [NSMutableString stringWithFormat:@"%@",string];
    if (tempArray.count>0) {
        for (int i=0; i<tempArray.count; i++) {
            NSString *tagString = [tempArray objectAtIndex:i];
            NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",tagString];
            NSRange range0 = [contentString rangeOfString:tagString];
            if (range0.location != NSNotFound) {
                NSRange range = [mutableString rangeOfString:@"时间"];
                if (range.location != NSNotFound) {
                    NSRange range1 = [mutableString rangeOfString:@"="];
                    if (range1.location != NSNotFound) {
                        NSString *tempStr1=[mutableString stringByReplacingOccurrencesOfString:@"[[" withString:@""];
                        NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                        NSArray *array = [tempStr2 componentsSeparatedByString:@"="];
                        NSString *d_str = [array objectAtIndex:1];
                        [contentString replaceCharactersInRange:range0 withString:d_str];
                    }
                }else {
                    NSRange range2 = [mutableString rangeOfString:@"选项"];
                    if (range2.location != NSNotFound) {
                        NSRange range3 = [mutableString rangeOfString:@"="];
                        if (range3.location != NSNotFound){
                            NSString *tempStr1=[mutableString stringByReplacingOccurrencesOfString:@"[[" withString:@""];
                            NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                            NSArray *array = [tempStr2 componentsSeparatedByString:@"="];
                            NSString *d_str = [array objectAtIndex:1];
                            NSArray *array2 = [d_str componentsSeparatedByString:@"-"];
                            NSString *dd_str = [array2 objectAtIndex:0];
                            [contentString replaceCharactersInRange:range0 withString:dd_str];
                        }
                    }else {
                        NSRange range4 = [mutableString rangeOfString:@"填空"];
                        if (range4.location != NSNotFound) {
                            NSRange range5 = [mutableString rangeOfString:@"="];
                            if (range5.location != NSNotFound) {
                                NSString *tempStr1=[mutableString stringByReplacingOccurrencesOfString:@"[[" withString:@""];
                                NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                                NSArray *array = [tempStr2 componentsSeparatedByString:@"="];
                                NSString *d_str = [array objectAtIndex:1];
                                [contentString replaceCharactersInRange:range0 withString:d_str];
                            }
                        }
                    }
                }
            }
        }
    }
    return contentString;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _voiceBtn.hidden= YES;
    NSString *orgin=_messageConent.text;
    switch (_msgStyle) {
        case CMRMessageCellStyleMe:
        {
            [_userHead setHidden:YES];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-[CMRDataService shared].headSize, INSETS*2+TIME_HEIGHT,[CMRDataService shared].headSize , [CMRDataService shared].headSize)];
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            
            if (_messageType==CMRMessageTypeRemind) {
                CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake((320-[CMRDataService shared].headSize-3*INSETS-60), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];

                CGFloat width = 0;
                if (textSize.width-115<0.00000001) {
                    width = 115;
                }else {
                    width = textSize.width;
                }
                _titleLab.hidden = NO;
                _titleLab.text = @"自动提醒已发送";
                [_messageConent setFont:[UIFont systemFontOfSize:13]];
                [_messageConent setTextColor:[UIColor grayColor]];
                
                _bubbleBg.frame=CGRectMake(CELL_WIDTH-INSETS*2-[CMRDataService shared].headSize-width-60, INSETS*2+TIME_HEIGHT, width+60, textSize.height+INSETS*7+18);
                
                [_titleLab setFrame:CGRectMake(_bubbleBg.frame.origin.x+45, _bubbleBg.frame.origin.y+INSETS, 110, 18)];
                
                [_messageConent setFrame:CGRectMake(_bubbleBg.frame.origin.x+45, _titleLab.frame.origin.y+18+INSETS*2, width, textSize.height)];
               
                [_chatImage setHidden:NO];
                [_chatImage setFrame:CGRectMake(_bubbleBg.frame.origin.x+10,INSETS*3+TIME_HEIGHT ,30,30)];
                [_messageConent setText:orgin];
            }
            else if (_messageType==CMRMessageTypeNote){
                CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake((320-[CMRDataService shared].headSize-3*INSETS-60), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat width = 0;
                if (textSize.width-60<0.00000001) {
                    width = 60;
                }else {
                    width = textSize.width;
                }
     
                _titleLab.hidden = NO;
                _titleLab.text = @"记录";
                [_messageConent setFont:[UIFont systemFontOfSize:13]];
                [_messageConent setTextColor:[UIColor grayColor]];
                
                _bubbleBg.frame=CGRectMake(CELL_WIDTH-INSETS*2-width-60, INSETS*2+TIME_HEIGHT, width+60, textSize.height+INSETS*7+18);
                
                [_titleLab setFrame:CGRectMake(_bubbleBg.frame.origin.x+45, _bubbleBg.frame.origin.y+INSETS, 110, 18)];
                
                [_messageConent setFrame:CGRectMake(_bubbleBg.frame.origin.x+45, _titleLab.frame.origin.y+18+INSETS*2, width, textSize.height)];
                
                [_chatImage setHidden:NO];
                [_chatImage setFrame:CGRectMake(_bubbleBg.frame.origin.x+10,INSETS*3+TIME_HEIGHT ,30,30)];
                [_messageConent setText:orgin];
            }
            else {
                CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-[CMRDataService shared].headSize-3*INSETS-60), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat height = 0;
                if (textSize.height-30<0) {//最少30
                    height=30;
                }else {
                    height = textSize.height;
                }

                _titleLab.hidden = YES;
                [_messageConent setFont:[UIFont systemFontOfSize:15]];
                [_messageConent setTextColor:[UIColor blackColor]];
                
                _bubbleBg.frame=CGRectMake(CELL_WIDTH-INSETS*2-textSize.width-60, INSETS*2+TIME_HEIGHT, textSize.width+60, height+INSETS*4);
                
                [_messageConent setFrame:CGRectMake(_bubbleBg.frame.origin.x+45, _bubbleBg.frame.origin.y+INSETS, textSize.width, height)];
                
                [_chatImage setHidden:NO];
                [_chatImage setFrame:CGRectMake(_bubbleBg.frame.origin.x+10,INSETS*3+TIME_HEIGHT ,30,30)];
            }
        }
            break;
        case CMRMessageCellStyleOther:
        {
            [_userHead setHidden:NO];
            if (_mediaType == CMRmediaTypeText) {
                CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-[CMRDataService shared].headSize-3*INSETS-60), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat height = 0;
                if (textSize.height-30<0) {//最少30
                    height=30;
                }else {
                    height = textSize.height;
                }
                
                _titleLab.hidden = YES;
                [_chatImage setHidden:YES];
                [_messageConent setFont:[UIFont systemFontOfSize:15]];
                [_messageConent setTextColor:[UIColor blackColor]];
                [_userHead setFrame:CGRectMake(INSETS, INSETS*2+TIME_HEIGHT,[CMRDataService shared].headSize , [CMRDataService shared].headSize)];
                
                [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
                _bubbleBg.frame=CGRectMake(2*INSETS+[CMRDataService shared].headSize, INSETS*2+TIME_HEIGHT, textSize.width+30, height+INSETS*4);
                
                [_messageConent setFrame:CGRectMake(_bubbleBg.frame.origin.x+15, (_bubbleBg.frame.size.height-height-INSETS*2)/2+_bubbleBg.frame.origin.y, textSize.width, height)];
            }
            else if (_mediaType == CMRmediaTypeImage){
                _titleLab.hidden = YES;
                _messageConent.hidden = YES;
                [_chatImage setHidden:NO];
                [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
                _bubbleBg.frame=CGRectMake(2*INSETS+[CMRDataService shared].headSize, INSETS*2+TIME_HEIGHT, 107, 120);
                
                [_chatImage setFrame:CGRectMake(_bubbleBg.frame.origin.x+16,INSETS*3+TIME_HEIGHT ,80,100)];
                [_userHead setFrame:CGRectMake(INSETS, INSETS*2+TIME_HEIGHT,[CMRDataService shared].headSize , [CMRDataService shared].headSize)];
            }
            else {
                
                _titleLab.hidden = YES;
                _messageConent.hidden = YES;
                [_chatImage setHidden:YES];
                _voiceBtn.hidden = NO;
                
                [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
                _bubbleBg.frame=CGRectMake(2*INSETS+[CMRDataService shared].headSize, INSETS*2+TIME_HEIGHT, 57, 50);
                
                [_voiceBtn setFrame:CGRectMake(_bubbleBg.frame.origin.x+16,INSETS*3+TIME_HEIGHT ,30,30)];
                [_userHead setFrame:CGRectMake(INSETS, INSETS*2+TIME_HEIGHT,[CMRDataService shared].headSize , [CMRDataService shared].headSize)];
            }
        }
            break;
        default:
            break;
    }
    _headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, [CMRDataService shared].headSize+6, [CMRDataService shared].headSize+6);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMessageObject:(CMRMessageObject *)aMessage
{
    [_messageConent setText:aMessage.messageContent];
    [_timeLab setText:[NSString stringWithFormat:@"   %@",aMessage.messageDate]];
    _messageType = [aMessage.messageType intValue];
    _mediaType = [aMessage.mediaType intValue];
}
-(void)setHeadImage:(NSString *)head
{
    if (![head isKindOfClass:[NSNull class]]) {
        NSURL *url = [NSURL URLWithString:head];
        [_userHead setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserHeaderImageBox"]];
    }
}
-(void)setChatImage:(UIImage *)chatImage
{
    [_chatImage setImage:chatImage];
}
-(void)getImageWithStr:(NSString *)str {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://116.255.202.113:3002%@",str]];
    [_chatImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserHeaderImageBox"]];
    [_chatImage addDetailShow];
}

@end
