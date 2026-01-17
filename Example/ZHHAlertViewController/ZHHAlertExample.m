//
//  ZHHAlertExample.m
//  ZHHAlertViewController_Example
//
//  Created by 桃色三岁 on 2022/7/27.
//  Copyright © 2022 桃色三岁y. All rights reserved.
//

#import "ZHHAlertExample.h"
/// RGB颜色(16进制)
#define UIColorHexRGBA(rgbValue, alphaValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(alphaValue)]

#define UIColorHexRGB(rgbValue)    UIColorHexRGBA(rgbValue,1.0)
#define kFontSizeArialBoldMT(fontSize)  [UIFont fontWithName:@"Arial-BoldMT"        size:fontSize]
#define kFontSizeRegular(fontSize)      [UIFont fontWithName:@"PingFangSC-Regular"  size:fontSize]


@implementation UIColor (ZHHColors)
/// 标题文字颜色
+ (instancetype)zhh_titleColor {
    return UIColorHexRGB(0x333333);
}

/// 副标题文字颜色
+ (instancetype)zhh_subtitleColor {
    return UIColorHexRGB(0x666666);
}

/// 正文字颜色
+ (instancetype)zhh_contentColor {
    return UIColorHexRGB(0x999999);
}
/// 颜色#F55B63 rgba(245, 91, 99, 1)
+ (instancetype)zhh_textColorF55B63 {
    return UIColorHexRGB(0xF55B63);
}
/// 按钮普通颜色
+ (instancetype)zhh_enableBtnColor {
    return UIColorHexRGB(0xFFDF0F);
}

/// 按钮禁用颜色颜色
+ (instancetype)zhh_disabledBtnColor {
    return UIColorHexRGBA(0xFFDF0F,0.5);
}

/// 按钮高亮颜色
+ (instancetype)zhh_highlightBtnColor {
    return UIColorHexRGB(0xFFD500);
}
/// 颜色#F8F7F7
+ (instancetype)zhh_textColorF8F7F7 {
    return UIColorHexRGB(0xF8F7F7);
}
@end

@interface ZHHAlertExample () <ZHHAlertViewControllerDelegate>

@end

@implementation ZHHAlertExample

+ (instancetype)sharedInstance {
    static ZHHAlertExample *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZHHAlertExample alloc] init];
    });
    return instance;
}

#pragma mark - 基础示例

/// 基础提示框（普通短文本提示）
- (void)showBasicAlert {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    
    popup.titleTopPadding = 15;
    popup.contentLeftRightPadding = 20;
    popup.titleBottomPadding = 10;
    popup.buttonTopPadding = 15;
    popup.buttonHeight = 44;
    popup.title = @"退出登录";
    popup.content = @"退出登录后不会删除任何历史数据\n下次登录依然可使用";

    popup.cancelButtonTitle = @"取消";
    popup.otherButtonTitle = @"退出";
    
    popup.titleLabel.textColor = UIColor.redColor;
    
    popup.cancelButtonAction = ^{
        NSLog(@"通过block点击了取消按钮");
    };
    
    popup.otherButtonAction = ^{
        NSLog(@"通过block点击了其他按钮");
    };
    
    [popup show];
}

/// 长文本提示（可滚动）
- (void)showLongTextAlert {
    
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。夕阳的余晖洒在静谧的湖面上，湖水波光粼粼，犹如无数颗璀璨的星星闪耀。天空中，几只归巢的鸟儿划过天际，鸣叫声在空旷的原野中回荡。远处的山峦笼罩在薄薄的雾气中，仿佛披上了一层神秘的面纱。这一刻，大自然仿佛在低声吟唱着一首古老的诗歌。那诗句里，有着草木的清香，有着流年的印记，更有着人们心中的眷恋与不舍。一阵清风吹过，湖边的芦苇轻轻摇曳，发出沙沙的声响，仿佛在低声细语。那声音轻柔而温暖，如同母亲的呢喃，抚慰着人们的心灵。夜幕渐渐降临，星星一颗颗点缀在深蓝的天幕上。此时，天地万物都进入了宁静的时刻，唯有那颗心，还在追寻着诗意的远方。在这个秋夜里，万物归于沉寂，而心中那抹不灭的诗意，却如同夜空中的星星，永远闪烁在我们心底，照亮着前行的路秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    
    popup.buttonTopPadding = 5;
    popup.shouldDimBackgroundWhenShowInWindow = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    [popup show];
}

/// 无标题提示
- (void)showNoTitleAlert {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.content = @"这是一个无标题的提示框";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    // 无标题时，调整间距以获得更好的视觉效果
    popup.titleTopPadding = 40.0;   // 内容距顶部的间距（无标题时 titleTopPadding 作为内容的顶部间距）
    popup.buttonTopPadding = 0.0;  // 内容与按钮的间距
    popup.shouldDimBackgroundWhenShowInWindow = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    [popup show];
}

/// 只有标题提示（无内容）
- (void)showTitleOnlyAlert {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    // 只有标题时，调整间距以获得更好的视觉效果
    popup.titleTopPadding = 40.0;   // 内容距顶部的间距（无内容时为 40）
    popup.buttonTopPadding = 0.0;    // 按钮距标题的间距
    popup.shouldDimBackgroundWhenShowInWindow = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    [popup show];
}

/// 单按钮提示
- (void)showSingleButtonAlert {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"偶尔欣赏一下窗外的景色";
    popup.otherButtonTitle = @"确定";
    // 单按钮时，调整间距以获得更好的视觉效果
    popup.titleBottomPadding = 15.0;   // 标题与内容的间距
    popup.buttonTopPadding = 20.0;     // 内容与按钮的间距
    popup.buttonBottomPadding = 0.0;   // 按钮距底部的间距
    [popup show];
}

#pragma mark - 样式自定义

/// 自定义按钮样式
- (void)showCustomButtonStyle {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    
    popup.titleTopPadding = 25;
    popup.titleBottomPadding = 15;
    popup.buttonSpacing = 10;
    popup.buttonHeight = 40;
    popup.buttonBottomPadding = 20;
    popup.buttonLeftRightPadding = 20;
    popup.buttonTopPadding = 20;
    popup.title = @"退出登录";
    popup.content = @"退出登录后不会删除任何历史数据\n下次登录依然可使用";

    popup.cancelButtonTitle = @"取消";
    popup.otherButtonTitle = @"退出";
    
    popup.titleLabel.textColor = UIColor.redColor;
    [popup.otherButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [popup.otherButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColor.zhh_textColorF55B63] forState:UIControlStateNormal];
    [popup.otherButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColorHexRGB(0xF5474F)] forState:UIControlStateHighlighted];
    popup.otherButton.zhh_cornerRadius = 8;
    [popup.cancelButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [popup.cancelButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColor.zhh_enableBtnColor] forState:UIControlStateNormal];
    [popup.cancelButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColor.zhh_highlightBtnColor] forState:UIControlStateHighlighted];
    popup.cancelButton.zhh_cornerRadius = 8;
    
    popup.delegate = self;

    [popup show];
}

/// 自定义背景颜色
- (void)showCustomBackgroundColor {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"偶尔欣赏一下窗外的景色";
    popup.otherButtonTitle = @"好的";
    popup.cancelButtonTitle = @"取消";
    popup.backgroundColor = UIColor.orangeColor;
    [popup show];
}

/// 自定义尺寸
- (void)showCustomSize {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"这是一个自定义尺寸的提示框";
    popup.otherButtonTitle = @"好的";
    popup.cancelButtonTitle = @"取消";
    popup.width = 320;
    popup.height = 200;
    [popup show];
}

/// 自定义圆角
- (void)showCustomCornerRadius {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"这是一个大圆角的提示框";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    popup.cornerRadius = 20.0;
    [popup show];
}

/// 按钮位置调整（取消按钮在右侧）
- (void)showButtonPositionRight {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"取消按钮显示在右侧";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    popup.cancelButtonPositionRight = YES;
    [popup show];
}

#pragma mark - 动画示例

/// 默认动画
- (void)showDefaultAnimation {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"默认动画效果";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    popup.appearAnimationType = ZHHAlertViewAnimationTypeDefault;
    popup.disappearAnimationType = ZHHAlertViewAnimationTypeDefault;
    [popup show];
}


#pragma mark - 交互行为

/// 点击外部关闭
- (void)showDismissOnOutsideTap {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"点击外部区域可以关闭此弹窗";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    popup.shouldDimBackgroundWhenShowInWindow = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    [popup show];
}

/// 点击按钮不自动关闭
- (void)showNoAutoDismiss {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"点击按钮不会自动关闭，需要手动调用 dismiss";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    popup.shouldDismissOnActionButtonClicked = NO;
    
    popup.otherButtonAction = ^{
        NSLog(@"点击了确定按钮，但弹窗不会自动关闭");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popup dismiss];
        });
    };
    
    [popup show];
}

/// 在指定视图中显示
- (void)showInCustomView {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"这个弹窗显示在指定的视图中，而不是窗口中";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    popup.shouldDimBackgroundWhenShowInView = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    
    // 注意：这里需要在有父视图的情况下调用，示例中使用 self.view
    // 在实际使用时，应该传入合适的父视图
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if (topVC.view) {
        [popup showInView:topVC.view];
    } else {
        [popup show];
    }
}

#pragma mark - 自定义视图

/// 自定义内容视图
- (void)showCustomContentView {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.cancelButtonTitle = @"取消";
    popup.otherButtonTitle = @"退出";
    
    // 创建自定义内容视图
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 260, 260)];
    customLabel.text = @"这是一个自定义的内容视图\n你可以在这里放置任何你想要的视图元素\n比如图片、按钮、输入框等";
    customLabel.numberOfLines = 0;
    customLabel.textAlignment = NSTextAlignmentCenter;
    customLabel.textColor = UIColor.blackColor;
    customLabel.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:customLabel];
    
    popup.customContentView = contentView;
    
    popup.cancelButtonAction = ^{
        NSLog(@"Cancel Clicked");
    };
    
    popup.otherButtonAction = ^{
        NSLog(@"OK Clicked");
    };
    
    [popup show];
}

/// 使用代理回调
- (void)showWithDelegate {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"这个弹窗使用代理来处理按钮点击事件";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    popup.delegate = self;
    [popup show];
}

/// 使用 Block 回调
- (void)showWithBlockCallback {
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"这个弹窗使用 Block 来处理按钮点击事件";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    
    popup.cancelButtonAction = ^{
        NSLog(@"通过 Block 点击了取消按钮");
    };
    
    popup.otherButtonAction = ^{
        NSLog(@"通过 Block 点击了确定按钮");
    };
    
    [popup show];
}

#pragma mark - ZHHAlertViewControllerDelegate

- (void)alertViewDidClickCancelButton:(ZHHAlertViewController *)alertView {
    NSLog(@"通过代理点击了取消按钮");
}

- (void)alertViewDidClickOtherButton:(ZHHAlertViewController *)alertView {
    NSLog(@"通过代理点击了其他按钮");
}

@end
