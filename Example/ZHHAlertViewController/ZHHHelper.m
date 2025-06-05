//
//  ZHHHelper.m
//  ZHHAlertViewController_Example
//
//  Created by 桃色三岁 on 2022/7/27.
//  Copyright © 2022 桃色三岁y. All rights reserved.
//

#import "ZHHHelper.h"
/// RGB颜色(16进制)
#define UIColorHexRGBA(rgbValue, alphaValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(alphaValue)]

#define UIColorHexRGB(rgbValue)    UIColorHexRGBA(rgbValue,1.0)
#define kFontSizeArialBoldMT(fontSize)  [UIFont fontWithName:@"Arial-BoldMT"        size:fontSize]
#define kFontSizeRegular(fontSize)      [UIFont fontWithName:@"PingFangSC-Regular"  size:fontSize]



@implementation ZHHPopupModel

@end


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

@interface ZHHHelper () <ZHHAlertViewControllerDelegate>

@end

@implementation ZHHHelper

+ (instancetype)sharedInstance {
    static ZHHHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZHHHelper alloc] init];
    });
    return instance;
}

/// 长文本提示
- (void)nxm_make_multiple_text{
    
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。夕阳的余晖洒在静谧的湖面上，湖水波光粼粼，犹如无数颗璀璨的星星闪耀。天空中，几只归巢的鸟儿划过天际，鸣叫声在空旷的原野中回荡。远处的山峦笼罩在薄薄的雾气中，仿佛披上了一层神秘的面纱。这一刻，大自然仿佛在低声吟唱着一首古老的诗歌。那诗句里，有着草木的清香，有着流年的印记，更有着人们心中的眷恋与不舍。一阵清风吹过，湖边的芦苇轻轻摇曳，发出沙沙的声响，仿佛在低声细语。那声音轻柔而温暖，如同母亲的呢喃，抚慰着人们的心灵。夜幕渐渐降临，星星一颗颗点缀在深蓝的天幕上。此时，天地万物都进入了宁静的时刻，唯有那颗心，还在追寻着诗意的远方。在这个秋夜里，万物归于沉寂，而心中那抹不灭的诗意，却如同夜空中的星星，永远闪烁在我们心底，照亮着前行的路秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。";
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    
    popup.buttonTopPadding = 5;
    popup.shouldDimBackgroundWhenShowInView = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    [popup show];
}

/// 无标题文本提示
- (void)nxm_make_untitled_text{
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.otherButtonTitle = @"确定";
    popup.cancelButtonTitle = @"取消";
    popup.shouldDimBackgroundWhenShowInView = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    [popup show];
}

/// 单个按钮
- (void)nxm_make_single_button{
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 135)];
    popup.content = @"偶尔欣赏一下窗外的景色";
    popup.otherButtonTitle = @"确定";
    popup.titleBottomPadding = 25;
    [popup show];
}


/// 自定义背景颜色
- (void)nxm_make_custom_background_color{
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"偶尔欣赏一下窗外的景色";
    popup.otherButtonTitle = @"好的";
    popup.cancelButtonTitle = @"取消";
    popup.backgroundColor = UIColor.orangeColor;
    [popup show];
}

/// 自定义背景图片
- (void)nxm_make_custom_background_image:(CGSize)size{

    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"偶尔欣赏一下窗外的景色";
    popup.otherButtonTitle = @"好的";
    popup.cancelButtonTitle = @"取消";
    [popup show];
}

/// 自定义宽
- (void)nxm_make_custom_frame:(CGSize)size{

    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"偶尔欣赏一下窗外的景色";
    popup.otherButtonTitle = @"好的";
    popup.cancelButtonTitle = @"取消";
    popup.width = 300;
    popup.appearAnimationType = ZHHAlertViewAnimationTypeNone;
    [popup show];
}

/// 自定义宽高
- (void)nxm_make_custom_size {

    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    popup.title = @"提示";
    popup.content = @"偶尔欣赏一下窗外的景色";
    popup.otherButtonTitle = @"好的";
    popup.cancelButtonTitle = @"取消";
    popup.width = 300;
    popup.appearAnimationType = ZHHAlertViewAnimationTypeNone;
    [popup show];
}

/// 自定义View
- (void)nxm_make_custom_view:(CGSize)size{
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.cancelButtonTitle = @"取消";
    popup.otherButtonTitle = @"退出";
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    contentView.backgroundColor = [UIColor yellowColor];
    popup.customContentView = contentView;
    [popup show];
    
    popup.cancelButtonAction = ^{
        NSLog(@"Cancel Clicked");
    };
    
    popup.otherButtonAction = ^{
        NSLog(@"OK Clicked");
    };
}

- (void)nxm_make_fade_in{
    
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"偶尔欣赏一下窗外的景色";
    popup.otherButtonTitle = @"好的";
    popup.cancelButtonTitle = @"取消";
    popup.appearAnimationType = ZHHAlertViewAnimationTypeFadeIn;
    popup.disappearAnimationType = ZHHAlertViewAnimationTypeFadeOut;
    
    popup.appearTime = 1;
    popup.disappearTime = 1;
    [popup show];
}

- (void)nxm_make_from_left {
    
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"提示";
    popup.content = @"左边出，右边进";
    popup.otherButtonTitle = @"OK";
    popup.cancelButtonTitle = @"Cancel";

    popup.appearAnimationType = ZHHAlertViewAnimationTypeFlyLeft;
    popup.disappearAnimationType = ZHHAlertViewAnimationTypeFlyRight;
    
    popup.appearTime = 1;
    popup.disappearTime = 1;
    [popup show];
}

- (void)nxm_make_exit{
    
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    
    popup.titleTopPadding = 15;
    popup.contentLeftRightPadding = 20;
    popup.titleBottomPadding = 10;
    popup.buttonTopPadding = 15;
//    popup.buttonSpacing = 10;
    popup.buttonHeight = 44;
//    popup.buttonBottomPadding = 10;
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

- (void)nxm_make_custom_button {
    
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    
    popup.titleTopPadding = 25;
//    popup.contentLeftRightPadding = 20;
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

- (void)alertViewDidClickCancelButton:(ZHHAlertViewController *)alertView {
    NSLog(@"通过代理点击了取消按钮");
}

- (void)nxm_make_need_update:(void (^)(void))completionBlock{
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] init];
    popup.title = @"一篇短文";
    popup.content = @"秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。夕阳的余晖洒在静谧的湖面上，湖水波光粼粼，犹如无数颗璀璨的星星闪耀。天空中，几只归巢的鸟儿划过天际，鸣叫声在空旷的原野中回荡。远处的山峦笼罩在薄薄的雾气中，仿佛披上了一层神秘的面纱。这一刻，大自然仿佛在低声吟唱着一首古老的诗歌。那诗句里，有着草木的清香，有着流年的印记，更有着人们心中的眷恋与不舍。一阵清风吹过，湖边的芦苇轻轻摇曳，发出沙沙的声响，仿佛在低声细语。那声音轻柔而温暖，如同母亲的呢喃，抚慰着人们的心灵。夜幕渐渐降临，星星一颗颗点缀在深蓝的天幕上。此时，天地万物都进入了宁静的时刻，唯有那颗心，还在追寻着诗意的远方。在这个秋夜里，万物归于沉寂，而心中那抹不灭的诗意，却如同夜空中的星星，永远闪烁在我们心底，照亮着前行的路。";
    popup.cancelButtonTitle = @"取消";
    popup.otherButtonTitle = @"确定";

    popup.buttonTopPadding = 5;

    [popup show];
}

@end
