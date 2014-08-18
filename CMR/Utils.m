//
//  Utils.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "Utils.h"



@implementation Utils

+ (NSString *)isExistenceNetwork {
    NSString *str = nil;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			str = @"NotReachable";
            break;
        case ReachableViaWWAN:
			str = @"ReachableViaWWAN";
            break;
        case ReachableViaWiFi:
			str = @"ReachableViaWiFi";
            break;
    }
    return str;
}


+ (NSString *)formateDate:(NSString *)date{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] init]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    NSDate* startDate = [inputFormatter dateFromString:date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *str = [outputFormatter stringFromDate:startDate];
    return str;
}
+ (NSString *)getNowDateFromatAnDate {
    NSDate *anyDate = [NSDate date];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    //转为string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString *timeString = [dateFormatter stringFromDate:destinationDateNow];
    
    return timeString;
}


+(NSString *)createPostURL:(NSMutableDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

+(NSMutableURLRequest *)getRequest:(NSMutableDictionary *)params string:(NSString *)theStr{
    NSString *postURL=[Utils createPostURL:params];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:theStr]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return theRequest;
}
+ (void)errorAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"移动CMR提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+ (UIImage*)imageFileNamed:(NSString*)name{
	return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name]];
}

+(UIButton *)initSimpleButton:(CGRect)rect
						title:(NSString *)title
				  normalImage:(NSString *)imageName
				  highlighted:(NSString *)imageName_highlighted{
	UIButton *l_button = [[UIButton alloc] init];
	UIImage* imageUnselected = [Utils imageFileNamed:imageName];
	imageUnselected = [imageUnselected stretchableImageWithLeftCapWidth:23 topCapHeight:imageUnselected.size.height];
	UIImage* imageSelected = [Utils imageFileNamed:imageName_highlighted];
	imageSelected = [imageSelected stretchableImageWithLeftCapWidth:23 topCapHeight:imageSelected.size.height];
	[l_button setBackgroundImage:imageUnselected forState:UIControlStateNormal];
	[l_button setBackgroundImage:imageSelected forState:UIControlStateHighlighted];
	[l_button setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0] forState:UIControlStateNormal];
	[l_button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	l_button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14.0];
	l_button.titleLabel.textAlignment = NSTextAlignmentCenter;
	l_button.frame = CGRectMake(rect.origin.x,
								rect.origin.y,
								rect.size.width,
								imageUnselected.size.height);
	[l_button setTitle:title forState:UIControlStateNormal];
	return l_button;
}
@end
