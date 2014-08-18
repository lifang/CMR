//
//  CMRBaseDao.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface CMRBaseDao : NSObject

@property (nonatomic, strong) FMDatabase *db;

@end
