//
//  ViewController.m
//  QLDemoProject
//
//  Created by paramita on 2018/10/30.
//  Copyright © 2018 paramita. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

#import "QRCodeViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) NSArray *dataArrayFromLocal;
@property (retain, nonatomic) NSArray *dataArrayFromFramwork;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArrayFromLocal.count;
    }
    return self.dataArrayFromFramwork.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    NSDictionary *dic = nil;
    if (indexPath.section == 0) {
        dic = self.dataArrayFromLocal[indexPath.row];
    }else{
        dic = self.dataArrayFromFramwork[indexPath.row];
    }
    
    cell.textLabel.text = dic.allKeys.firstObject;
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"本地原生";
    }else{
        return @"框架生成";
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = nil;
    if (indexPath.section == 0) {
        dic = self.dataArrayFromLocal[indexPath.row];
    }else{
        dic = self.dataArrayFromFramwork[indexPath.row];
    }
    
    NSString *name = dic.allValues.firstObject;
    @try {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:name];
        [self.navigationController pushViewController:vc animated:YES];
    } @catch (NSException *exception) {
        Class cls = NSClassFromString(name);
        if (cls) {
            [self.navigationController pushViewController:[cls new] animated:YES];
        }        
    }
}

#pragma mark - getter and setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataArrayFromLocal {
    if (!_dataArrayFromLocal) {
        _dataArrayFromLocal = @[
                                
                                ];
    }
    return _dataArrayFromLocal;
}

- (NSArray *)dataArrayFromFramwork {
    if (!_dataArrayFromFramwork) {
        _dataArrayFromFramwork = @[
                                   @{@"二维码功能" : @"QRCodeViewController"},
                                ];
    }
    return _dataArrayFromFramwork;
}

@end
