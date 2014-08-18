//
//  SendInterface.m
//  CMR
//
//  Created by comdosoft on 14-2-21.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "SendInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation SendInterface

-(void)getSendInterfaceDelegateWithContent:(NSString *)content andType:(NSString *)type andId:(NSString *)Id{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",type] forKey:@"msg_type"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",Id] forKey:@"client_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[CMRDataService shared].site_id] forKey:@"site_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@/messages/send_message_to_user",[CMRDataService shared].host];
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
                            [self.delegate getSendInfoDidFinished:[jsonData objectForKey:@"return_object"]];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSendInfoDidFailed:@"获取数据失败!"];
                        }
                    }else{
                        [self.delegate getSendInfoDidFailed:[jsonData objectForKey:@"message"]];
                    }
                }else {
                    [self.delegate getSendInfoDidFailed:@"获取数据失败!"];
                }
            }else{
                [self.delegate getSendInfoDidFailed:@"服务器连接失败，请稍后再试!"];
            }
        }else{
            [self.delegate getSendInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else {
        [self.delegate getSendInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSendInfoDidFailed:@"获取数据失败!"];
}

@end
