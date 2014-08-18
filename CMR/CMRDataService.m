//
//  CMRDataService.m
//  CMR
//
//  Created by comdosoft on 14-1-16.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRDataService.h"

@implementation CMRDataService

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (CMRDataService *)shared {
    static CMRDataService * cmrDataService = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cmrDataService = [[super alloc] init];
    });
    return cmrDataService;
}
#pragma mark - public method
- (void)hold
{
    _holding = YES;
    while (_holding) {
        [NSThread sleepForTimeInterval:1];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE);
    }
}

- (void)stop
{
    _holding = NO;
    DLog(@"end");
}

- (void)run
{
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier background_task;
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
        [self hold];
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
    
}

@end
