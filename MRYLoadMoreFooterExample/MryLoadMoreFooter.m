//
//  LoadMoreFooter.m
//
//  Created by baowei on 15/5/26.
//  Copyright (c) 2015年 CenturyDeAn. All rights reserved.
//

#import "MryLoadMoreFooter.h"

@interface MryLoadMoreFooter()

@property (nonatomic,weak) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitier;
@property (weak, nonatomic) IBOutlet UILabel *noMoreLabel;

@end

@implementation MryLoadMoreFooter

+ (instancetype)loadMoreFooter{
    return [[[NSBundle mainBundle]loadNibNamed:@"MryLoadMoreFooter" owner:nil options:nil]lastObject];
}

+ (instancetype)setupLoadMoreForTableView:(UITableView *)tableView{
    MryLoadMoreFooter *footer;
    if (tableView.tableFooterView == nil) {
        footer = [MryLoadMoreFooter loadMoreFooter];
        footer.isMoreFlag = YES;
        footer.status = UnLoading;
        footer.noMoreLabel.hidden = YES;
        tableView.tableFooterView = footer;
        footer.tableView = tableView;
    }
    return footer;
}

- (void)loadMoreData{
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
    }
}

- (void)observeTableView:(UITableView *)tableView{
    if (!self.isMoreFlag || self.status == Loading) {
        //没有更多数据了 或正在加载
        return;
    }
    
    CGFloat offsetY = tableView.contentOffset.y;
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = tableView.contentSize.height + tableView.contentInset.bottom - tableView.height;
    if ((offsetY >= judgeOffsetY - 20.0 && offsetY <= judgeOffsetY + 20.0) && tableView.contentSize.height > tableView.height) {
        [self beginLoading];
    }
    NSLog(@"%f",offsetY);
        NSLog(@"%f",judgeOffsetY);
        NSLog(@"%f",tableView.height);
    NSLog(@"%f",tableView.contentSize.height);
}

- (void)beginLoading{
    // 显示footer
    self.tableView.tableFooterView.hidden = NO;
    
    self.status = Loading;
    // 加载更多数据
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
    }
}

- (void)endLoading{
    self.status = UnLoading;
}

@end
