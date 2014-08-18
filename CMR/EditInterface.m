//
//  EditInterface.m
//  CMR
//
//  Created by comdosoft on 14-1-23.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "EditInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation EditInterface
//type  0编辑  1删除
-(void)getEditInterfaceDelegateWithMessageId:(NSString *)messageId andContent:(NSString *)content andType:(int)type{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",messageId] forKey:@"message_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@/messages/edit_record",[CMRDataService shared].host];
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
                            [self.delegate getEditInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getEditInfoDidFailed:@"获取数据失败!"];
                        }
                    }else{
                        [self.delegate getEditInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                }else {
                    [self.delegate getEditInfoDidFailed:@"获取数据失败!"];
                }
            }else{
                [self.delegate getEditInfoDidFailed:@"服务器连接失败，请稍后再试!"];
            }
        }else{
            [self.delegate getEditInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else {
        [self.delegate getEditInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getEditInfoDidFailed:@"获取数据失败!"];
}

@end
