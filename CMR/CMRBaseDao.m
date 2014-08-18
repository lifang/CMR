//
//  CMRBaseDao.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRBaseDao.h"
#import <sys/xattr.h>

@implementation CMRBaseDao

-(id)init
{
    if (self = [super init]) {
        //paths： ios下Document路径，Document为ios中可读写的文件夹
        NSFileManager *filemgr =[NSFileManager defaultManager];
        
        if (platform>5.0) {
            
            //如果系统是5.0.1及其以上这么干
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"Application"];
            
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
            {
                // Failed to create directory
            }
            
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:newDir]];
            
            //dbPath： 数据库路径，在Document中。
            NSString *dbPath = [newDir stringByAppendingPathComponent:@"caijingtong.db"];
            //创建数据库实例 db  这里说明下:如果路径中不存在"AiMeiYue.db"的文件,sqlite会自动创建"AiMeiYue.db"
            self.db = [FMDatabase databaseWithPath:dbPath] ;
            
        }else{
            
            //如果系统是5.0及其以上这么干
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"Application"];
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
            {
                // Failed to create directory
            }
            
            //dbPath： 数据库路径，在Document中。
            NSString *dbPath = [newDir stringByAppendingPathComponent:@"caijingtong.db"];
            //创建数据库实例 db  这里说明下:如果路径中不存在"AiMeiYue.db"的文件,sqlite会自动创建"AiMeiYue.db"
            self.db = [FMDatabase databaseWithPath:dbPath] ;
        }
        
        if (![self.db open]) {
            // NSLog(@"Could not open db.");
            self.db = nil;
        }
        
        //创建消息
        FMResultSet *rs = [self.db executeQuery:@"select messageId from SQLITE_MASTER where name = 'cmrMessage'"];
        
        if (![rs next]) {
            [rs close];
            [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS 'cmrMessage' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'messageFrom' VARCHAR, 'messageTo' VARCHAR, 'messageContent' VARCHAR, 'messageDate' DATETIME,'messageType' INTEGER )"];
        }
        
        [rs close];
        
        //创建登录信息表
        rs = [self.db executeQuery:@"select localID from SQLITE_MASTER where name = 'cmrUser'"];
        if (![rs next]) {
            [rs close];
            [self.db executeUpdate:@"CREATE  TABLE  IF NOT EXISTS 'cmrUser' ('localID' VARCHAR PRIMARY KEY  NOT NULL  UNIQUE , 'name' VARCHAR, 'phone' VARCHAR, 'userHead' VARCHAR, 'address' VARCHAR, 'remark' VARCHAR)"];
        }
        
        [rs close];
    }
    return self;
}
//添加不用备份的属性5.0.1
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    if (platform>=5.1) {//5.1的阻止备份
        
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            //NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }else if (platform>5.0 && platform<5.1){//5.0.1的阻止备份
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    return YES;
}

@end

