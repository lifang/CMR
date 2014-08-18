//
//  Utils.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface Utils : NSObject

+ (void)errorAlert:(NSString *)message;
+ (NSString *)isExistenceNetwork;
+ (NSString *)formateDate:(NSString *)date;
+ (NSString *)getNowDateFromatAnDate;
+ (NSMutableURLRequest *)getRequest:(NSMutableDictionary *)params string:(NSString *)theStr;
+(UIButton *)initSimpleButton:(CGRect)rect
						title:(NSString *)title
				  normalImage:(NSString *)imageName
				  highlighted:(NSString *)imageName_highlighted;
@end
