//
//  ZHHViewController.m
//  ZHHAlertViewController
//
//  Created by 桃色三岁y on 07/26/2022.
//  Copyright (c) 2022 桃色三岁y. All rights reserved.
//

#import "ZHHViewController.h"
#import "ZHHAlertExample.h"

@interface ZHHViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *dataSource; // 分组数据源
@property (strong, nonatomic) NSArray<NSString *> *sectionTitles; // 分组标题
@property (strong, nonatomic) UITableView *mainTableView;
@end

@implementation ZHHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ZHHAlertViewController 示例";
    
    // 分组组织示例
    self.sectionTitles = @[
        @"基础示例",
        @"样式自定义",
        @"动画示例",
        @"交互行为",
        @"自定义视图"
    ];
    
    self.dataSource = @[
        // 基础示例
        @[@"基础提示框",
          @"长文本提示（可滚动）",
          @"无标题提示",
          @"只有标题提示",
          @"单按钮提示"],
        
        // 样式自定义
        @[@"自定义按钮样式",
          @"自定义背景颜色",
          @"自定义尺寸",
          @"自定义圆角",
          @"按钮位置调整"],
        
        // 动画示例
        @[@"默认动画"],
        
        // 交互行为
        @[@"点击外部关闭",
          @"点击不自动关闭",
          @"在视图中显示"],
        
        // 自定义视图
        @[@"自定义内容视图",
          @"使用代理回调",
          @"使用 Block 回调"]
    ];
    
    self.mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = 50.0;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView;
    });
    [self.view addSubview:self.mainTableView];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZHHViewController"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ZHHViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZHHAlertExample *helper = [ZHHAlertExample sharedInstance];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    // 基础示例
    if (section == 0) {
        switch (row) {
            case 0:
                [helper showBasicAlert];
                break;
            case 1:
                [helper showLongTextAlert];
                break;
            case 2:
                [helper showNoTitleAlert];
                break;
            case 3:
                [helper showTitleOnlyAlert];
                break;
            case 4:
                [helper showSingleButtonAlert];
                break;
            default:
                break;
        }
    }
    // 样式自定义
    else if (section == 1) {
        switch (row) {
            case 0:
                [helper showCustomButtonStyle];
                break;
            case 1:
                [helper showCustomBackgroundColor];
                break;
            case 2:
                [helper showCustomSize];
                break;
            case 3:
                [helper showCustomCornerRadius];
                break;
            case 4:
                [helper showButtonPositionRight];
                break;
            default:
                break;
        }
    }
    // 动画示例
    else if (section == 2) {
        switch (row) {
            case 0:
                [helper showDefaultAnimation];
                break;
            default:
                break;
        }
    }
    // 交互行为
    else if (section == 3) {
        switch (row) {
            case 0:
                [helper showDismissOnOutsideTap];
                break;
            case 1:
                [helper showNoAutoDismiss];
                break;
            case 2:
                [helper showInCustomView];
                break;
            default:
                break;
        }
    }
    // 自定义视图
    else if (section == 4) {
        switch (row) {
            case 0:
                [helper showCustomContentView];
                break;
            case 1:
                [helper showWithDelegate];
                break;
            case 2:
                [helper showWithBlockCallback];
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
