//
//  LoadMoreFooter.m
//
//  Created by baowei on 15/5/26.
//  Copyright (c) 2015年 CenturyDeAn. All rights reserved.
//

#import "MryLoadMoreFooter.h"

@interface MryLoadMoreFooter()

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitier;
@property (weak, nonatomic) IBOutlet UILabel *noMoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *loadMoreBtn;

- (IBAction)loadMoreBtnClick:(UIButton *)sender;
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
        footer.loadMoreBtn.layer.cornerRadius = 5.f;
        footer.loadMoreBtn.layer.borderColor = [UIColor colorWithRed:180.f/255 green:180.f/255 blue:180.f/255 alpha:1].CGColor;
        footer.loadMoreBtn.layer.borderWidth = 0.5f;
        tableView.tableFooterView = footer;
    }
    
    return footer;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)loadMoreData{
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
    }
}

//新版本此方法不需使用 由KVO模式取代
//- (void)observeTableView:(UITableView *)tableView{
//    if (!self.isMoreFlag || self.status == Loading) {
//        //没有更多数据了 或正在加载
//        return;
//    }
//
//    CGFloat offsetY = tableView.contentOffset.y;
//    // 当最后一个cell完全显示在眼前时，contentOffset的y值
//    CGFloat judgeOffsetY = tableView.contentSize.height + tableView.contentInset.bottom - tableView.frame.size.height;
//    if ((offsetY >= judgeOffsetY - 20.0 && offsetY <= judgeOffsetY + 20.0) && tableView.contentSize.height > tableView.frame.size.height) {
//        [self beginLoading];
//    }
//    NSLog(@"%f",offsetY);
//        NSLog(@"%f",judgeOffsetY);
//        NSLog(@"%f",tableView.frame.size.height);
//    NSLog(@"%f",tableView.contentSize.height);
//}

//监听contentOffset变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (!self.isMoreFlag || self.status == Loading || self.status == FailLoad) {
            //没有更多数据了 或正在加载
            return;
        }
        UITableView *tableView = (UITableView *)self.superview;
        CGFloat offsetY = tableView.contentOffset.y;
        // 当最后一个cell完全显示在眼前时，contentOffset的y值
        CGFloat judgeOffsetY = tableView.contentSize.height + tableView.contentInset.bottom - tableView.frame.size.height;
        if ((offsetY >= judgeOffsetY - 20.0 && offsetY <= judgeOffsetY + 20.0) && tableView.contentSize.height > tableView.frame.size.height) {
            [self beginLoading];
        }
        //        NSLog(@"%f",offsetY);
        //        NSLog(@"%f",judgeOffsetY);
        //        NSLog(@"%f",self.tableView.frame.size.height);
        //        NSLog(@"%f",self.tableView.contentSize.height);
    }
}

- (void)beginLoading{
    
    UITableView *tableView = (UITableView *)self.superview;
    // 显示footer
    tableView.tableFooterView.hidden = NO;
    
    self.status = Loading;
    self.loadMoreBtn.hidden = YES;
    self.loadingView.hidden = NO;
    // 加载更多数据
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
    }
}

- (void)endLoading{
    self.status = UnLoading;
}

- (void)failLoad{
    self.status = FailLoad;
    self.loadMoreBtn.hidden = NO;
    self.loadingView.hidden = YES;
}

//- (void)dealloc{
//    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
//}

- (IBAction)loadMoreBtnClick:(UIButton *)sender {
    [self beginLoading];
}
@end
