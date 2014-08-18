//
//  ShieldInterface.m
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "ShieldInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation ShieldInterface

-(void)getShieldInterfaceDelegateWithID:(NSString *)str andType:(NSString *)type{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",str] forKey:@"person_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",type] forKey:@"isShield"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[CMRDataService shared].site_id] forKey:@"site_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@/clients/set_receive",[CMRDataService shared].host];
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
                            NSDictionary *staff = [jsonData objectForKey:@"return_object"];
                            [self.delegate getShieldInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getShieldInfoDidFailed:@"获取数据失败!"];
                        }
                    }else{
                        [self.delegate getShieldInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                }else {
                    [self.delegate getShieldInfoDidFailed:@"获取数据失败!"];
                }
            }else{
                [self.delegate getShieldInfoDidFailed:@"服务器连接失败，请稍后再试!"];
            }
        }else{
            [self.delegate getShieldInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else {
        [self.delegate getShieldInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getShieldInfoDidFailed:@"获取数据失败!"];
}

@end
