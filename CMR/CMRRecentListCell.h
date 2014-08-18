//
//  CMRRecentListCell.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMRMessageUserUnionObject.h"

@interface CMRRecentListCell : UITableViewCell
{
    UIImageView *_userHead;
    UIImageView *_bageView;
    UILabel *_bageNumber;
    UILabel *_userNickname;
    UILabel *_messageConent;
    UILabel *_timeLable;
    UIImageView *_cellBkg;
}

-(void)setUnionObject:(CMRMessageUserUnionObject *)aUnionObj;
-(void)setHeadImage:(NSString*)imageURL;
@end
