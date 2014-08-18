//
//  LogInterface.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "LogInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation LogInterface

-(void)getLogInterfaceDelegateWithName:(NSString *)theName andPassWord:(NSString *)thePassWord andToken:(NSString *)token {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",theName] forKey:@"mphone"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",thePassWord] forKey:@"password"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",token] forKey:@"token"];
    self.interfaceUrl = [NSString stringWithFormat:@"%@/clients/login",[CMRDataService shared].host];
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
                            [self.delegate getLogInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLogInfoDidFailed:@"登录失败!"];
                        }
                    }else{
                        [self.delegate getLogInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                }else {
                    [self.delegate getLogInfoDidFailed:@"登录失败!"];
                }
            }else{
                [self.delegate getLogInfoDidFailed:@"服务器连接失败，请稍后再试!"];
            }
        }else{
            [self.delegate getLogInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else {
        [self.delegate getLogInfoDidFailed:@"登录失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getLogInfoDidFailed:@"登录失败!"];
}

@end
