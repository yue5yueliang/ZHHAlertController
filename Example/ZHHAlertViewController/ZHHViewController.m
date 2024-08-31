//
//  ZHHViewController.m
//  ZHHAlertViewController
//
//  Created by 宁小陌y on 07/26/2022.
//  Copyright (c) 2022 宁小陌y. All rights reserved.
//

#import "ZHHViewController.h"
#import "ZHHHelper.h"

@interface ZHHViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UITableView *mainTableView;
@end

NSString *sampleTitle = @"Title";
NSString *shortSampleMessage = @"Hello World!";
NSString *sampleMessage = @"The quick brown fox jumps over the lazy dog.";
NSString *longSampleMessage = @"Yesterday, all my troubles seemed so far away. Now it looks as though they're here to stay. Oh, I believe in yesterday. Suddenly I'm not half the man I used to be. There's a shadow hanging over me. Oh, yesterday came suddenly.";

@implementation ZHHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"示例";
    self.dataSource = @[@"自定义样式",
                        @"普通提示",
                        @"长文本提示",
                        @"无标题文本提示",
                        @"一个按钮",
                        @"自定义背景颜色",
                        @"自定义背景背景",
                        @"自定义 Frame",
                        @"自定义 View",
                        @"淡入动画",
                        @"从左侧飞入"];
    self.mainTableView = ({
        UITableView *tableView = [UITableView new];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = 44.0;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.frame = self.view.frame;
        tableView;
    });
    [self.view addSubview:self.mainTableView];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZHHViewController"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ZHHViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
            [ZHHHelper nxm_make_need_update:^{
                
            }];
            break;
        case 1:
            [ZHHHelper nxm_make_exit];
            break;
        case 2:
            [ZHHHelper nxm_make_multiple_text];
            break;
        case 3:
            [ZHHHelper nxm_make_untitled_text];
            break;
        case 4:
            [ZHHHelper nxm_make_single_button];
            break;
        case 5:
            [ZHHHelper nxm_make_custom_background_color];
            break;
        case 6:
            [ZHHHelper nxm_make_custom_background_image:self.view.frame.size];
            break;
        case 7:
            [ZHHHelper nxm_make_custom_frame:self.view.frame.size];
            break;
        case 8:
            [ZHHHelper nxm_make_custom_view:self.view.frame.size];
            break;
        case 9:
            [ZHHHelper nxm_make_fade_in];
            break;
        case 10:
            [ZHHHelper nxm_make_from_left];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
