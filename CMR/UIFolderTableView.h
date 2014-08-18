//
//  UIFolderTableView.h
//  top100
//
//  Created by Dai Cloud on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FolderCoverView.h"

@class CAMediaTimingFunction;
@class UIFolderTableView;

typedef void (^FolderCompletionBlock)(void);
typedef void (^FolderCloseBlock)(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction);
typedef void (^FolderOpenBlock)(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction);

@protocol UIFolderTableViewDelegate <NSObject>

@optional
- (CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewWillReloadData:(UITableView *)tableView;
- (void)tableViewDidReloadData:(UITableView *)tableView;
@end

@interface UIFolderTableView : UITableView
{
    struct {
        unsigned int delegateWillReloadData:1;
        unsigned int delegateDidReloadData:1;
        unsigned int reloading:1;
    } _flags;
}

@property (strong, nonatomic) UIView *subClassContentView;
@property (assign, nonatomic) IBOutlet id<UIFolderTableViewDelegate> folderDelegate;

- (void)openFolderAtIndexPath:(NSIndexPath *)indexPath
              WithContentView:(UIView *)subClassContentView
                    openBlock:(FolderOpenBlock)openBlock 
                   closeBlock:(FolderCloseBlock)closeBlock
              completionBlock:(FolderCompletionBlock)completionBlock;
- (void)closeTheDoor;

@end
