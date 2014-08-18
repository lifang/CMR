//
//  TimeInterface.m
//  CMR
//
//  Created by comdosoft on 14-2-19.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "TimeInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation TimeInterface
-(void)getTimeInterfaceDelegateWithStart:(NSString *)start andEnd:(NSString *)end andType:(NSString *)type{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",start] forKey:@"receive_start"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",end] forKey:@"receive_end"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",type] forKey:@"receive_status"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[CMRDataService shared].site_id] forKey:@"site_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@/clients/set_undisturbed",[CMRDataService shared].host];
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [[request responseHeaders] allKeytoLowerCase];
    if (resultHeaders) {
        NSData *data = [[NSData alloc]initWithData:[request responseData]];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (jsonObject !=nil) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)jsonObject;
                if (jsonData) {
                    if ([[jsonData objectForKey:@"status"]intValue] == 1) {
                        @try {
                            [self.delegate getTimeInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getTimeInfoDidFailed:@"获取数据失败!"];
                        }
                    }else{
                        [self.delegate getTimeInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                }else {
                    [self.delegate getTimeInfoDidFailed:@"获取数据失败!"];
                }
            }else{
                [self.delegate getTimeInfoDidFailed:@"服务器连接失败，请稍后再试!"];
            }
        }else{
            [self.delegate getTimeInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else {
        [self.delegate getTimeInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getTimeInfoDidFailed:@"获取数据失败!"];
}
@end
