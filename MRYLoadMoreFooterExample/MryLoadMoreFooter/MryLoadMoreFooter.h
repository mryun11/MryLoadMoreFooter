//
//  LoadMoreFooter.h
//
//  Created by baowei on 15/5/26.
//  Copyright (c) 2015年 CenturyDeAn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UnLoading = 0,
    Loading,
    FailLoad
}Status;

@protocol MryLoadMoreFooterDelegate <NSObject>

@optional
- (void)loadMoreData;

@end

@interface MryLoadMoreFooter : UIView

@property (nonatomic,assign) BOOL isMoreFlag;
@property (nonatomic,assign) Status status;

@property (nonatomic,weak) id<MryLoadMoreFooterDelegate> delegate;

+ (instancetype)loadMoreFooter;

+ (instancetype)setupLoadMoreForTableView:(UITableView *)tableView;

- (void)observeTableView:(UITableView *)tableView;

- (void)endLoading;

- (void)failLoad;

@end
