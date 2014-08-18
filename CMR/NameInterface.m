//
//  NameInterface.m
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "NameInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation NameInterface
-(void)getNameInterfaceDelegateWithID:(NSString *)str andName:(NSString *)name andType:(NSString *)type{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",str] forKey:@"person_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",name] forKey:@"person_info"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",type] forKey:@"person_type"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[CMRDataService shared].site_id] forKey:@"site_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@/clients/edit_client",[CMRDataService shared].host];
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
                            [self.delegate getNameInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getNameInfoDidFailed:@"获取数据失败!"];
                        }
                    }else{
                        [self.delegate getNameInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                }else {
                    [self.delegate getNameInfoDidFailed:@"获取数据失败!"];
                }
            }else{
                [self.delegate getNameInfoDidFailed:@"服务器连接失败，请稍后再试!"];
            }
        }else{
            [self.delegate getNameInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else {
        [self.delegate getNameInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getNameInfoDidFailed:@"获取数据失败!"];
}
@end
