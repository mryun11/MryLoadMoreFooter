//
//  ViewController.m
//  MRYLoadMoreFooterExample
//
//  Created by mryun on 15/6/16.
//  Copyright (c) 2015年 MRY. All rights reserved.
//

#import "ViewController.h"
#import "MryLoadMoreFooter.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,MryLoadMoreFooterDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) MryLoadMoreFooter *footerView;

@property (assign, nonatomic) NSInteger rowCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rowCount = 20;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
    
    self.footerView = [MryLoadMoreFooter setupLoadMoreForTableView:self.tableView];
    self.footerView.delegate = self;
}

//MryLoadMoreFooterDelegate 代理方法
- (void)loadMoreData{
    //模拟网络请求
    [self performSelector:@selector(initData) withObject:nil afterDelay:2.0];
}

- (void)initData{
    self.rowCount += 20;
    [self.tableView reloadData];
    [self.footerView endLoading];
    if (self.rowCount >= 50) {
        //没有更多数据了
        self.tableView.tableFooterView = nil;
    }
}

//监听滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.footerView observeTableView:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
