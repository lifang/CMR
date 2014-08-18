//
//  SendMessageInterface.m
//  CMR
//
//  Created by comdosoft on 14-1-25.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "SendMessageInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation SendMessageInterface
-(void)getSendMessageInterfaceDelegateWithTo_userId:(NSString *)toId andContent:(NSString *)content andType:(NSString *)type{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",toId] forKey:@"to_user"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[CMRDataService shared].user_id] forKey:@"from_user"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",type] forKey:@"types"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[CMRDataService shared].site_id] forKey:@"site_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@/messages/make_record",[CMRDataService shared].host];
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
                            [self.delegate getSendMessageInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSendMessageInfoDidFailed:@"获取数据失败!"];
                        }
                    }else{
                        [self.delegate getSendMessageInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                }else {
                    [self.delegate getSendMessageInfoDidFailed:@"获取数据失败!"];
                }
            }else{
                [self.delegate getSendMessageInfoDidFailed:@"服务器连接失败，请稍后再试!"];
            }
        }else{
            [self.delegate getSendMessageInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else {
        [self.delegate getSendMessageInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSendMessageInfoDidFailed:@"获取数据失败!"];
}

@end
