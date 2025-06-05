//
//  ZHHHelper.m
//  ZHHAlertViewController_Example
//
//  Created by 宁小陌 on 2022/7/27.
//  Copyright © 2022 宁小陌y. All rights reserved.
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
    
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.title = @"提示";
    model.content = @"秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。夕阳的余晖洒在静谧的湖面上，湖水波光粼粼，犹如无数颗璀璨的星星闪耀。天空中，几只归巢的鸟儿划过天际，鸣叫声在空旷的原野中回荡。远处的山峦笼罩在薄薄的雾气中，仿佛披上了一层神秘的面纱。这一刻，大自然仿佛在低声吟唱着一首古老的诗歌。那诗句里，有着草木的清香，有着流年的印记，更有着人们心中的眷恋与不舍。一阵清风吹过，湖边的芦苇轻轻摇曳，发出沙沙的声响，仿佛在低声细语。那声音轻柔而温暖，如同母亲的呢喃，抚慰着人们的心灵。夜幕渐渐降临，星星一颗颗点缀在深蓝的天幕上。此时，天地万物都进入了宁静的时刻，唯有那颗心，还在追寻着诗意的远方。在这个秋夜里，万物归于沉寂，而心中那抹不灭的诗意，却如同夜空中的星星，永远闪烁在我们心底，照亮着前行的路秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。";
    model.otherButtonTitle = @"确定";
    model.cancelButtonTitle = @"取消";
    
    model.buttonTopPadding = 5;
    
    
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithModel:model];
    popup.shouldDimBackgroundWhenShowInView = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    [popup show];
}

/// 无标题文本提示
- (void)nxm_make_untitled_text{
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.otherButtonTitle = @"确定";
    model.cancelButtonTitle = @"取消";
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithModel:model];
    popup.shouldDimBackgroundWhenShowInView = YES;
    popup.shouldDismissOnOutsideTapped = YES;
    [popup show];
}

/// 单个按钮
- (void)nxm_make_single_button{
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.content = @"偶尔欣赏一下窗外的景色";
    model.otherButtonTitle = @"确定";
    model.titleBottomPadding = 25;
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithModel:model];
    [popup show];
}


/// 自定义背景颜色
- (void)nxm_make_custom_background_color{
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.title = @"提示";
    model.content = @"偶尔欣赏一下窗外的景色";
    model.otherButtonTitle = @"好的";
    model.cancelButtonTitle = @"取消";
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithModel:model];
    popup.backgroundColor = UIColor.orangeColor;
    [popup show];
}

/// 自定义背景图片
- (void)nxm_make_custom_background_image:(CGSize)size{

    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.title = @"提示";
    model.content = @"偶尔欣赏一下窗外的景色";
    model.otherButtonTitle = @"好的";
    model.cancelButtonTitle = @"取消";
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithModel:model];
    [popup show];
}

/// 自定义宽高
- (void)nxm_make_custom_frame:(CGSize)size{

    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.title = @"提示";
    model.content = @"偶尔欣赏一下窗外的景色";
    model.otherButtonTitle = @"好的";
    model.cancelButtonTitle = @"取消";
    model.width = 300;
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithModel:model];
    popup.appearAnimationType = ZHHAlertViewAnimationTypeNone;
    [popup show];
}

/// 自定义View
- (void)nxm_make_custom_view:(CGSize)size{
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.cancelButtonTitle = @"取消";
    model.otherButtonTitle = @"退出";
//    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:@"轻松一点，胜人一筹" cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithModel:model];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    contentView.backgroundColor = [UIColor yellowColor];
    alertView.customContentView = contentView;
    [alertView show];
    
    alertView.cancelButtonAction = ^{
        NSLog(@"Cancel Clicked");
    };
    
    alertView.otherButtonAction = ^{
        NSLog(@"OK Clicked");
    };
}

- (void)nxm_make_fade_in{
    
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.title = @"提示";
    model.content = @"偶尔欣赏一下窗外的景色";
    model.otherButtonTitle = @"好的";
    model.cancelButtonTitle = @"取消";
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithModel:model];
    popup.appearAnimationType = ZHHAlertViewAnimationTypeFadeIn;
    popup.disappearAnimationType = ZHHAlertViewAnimationTypeFadeOut;
    
    popup.appearTime = 1;
    popup.disappearTime = 1;
    [popup show];
}

- (void)nxm_make_from_left {
    
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.title = @"提示";
    model.content = @"左边出，右边进";
    model.otherButtonTitle = @"OK";
    model.cancelButtonTitle = @"Cancel";
    ZHHAlertViewController *popup = [[ZHHAlertViewController alloc] initWithModel:model];
    popup.appearAnimationType = ZHHAlertViewAnimationTypeFlyLeft;
    popup.disappearAnimationType = ZHHAlertViewAnimationTypeFlyRight;
    
    popup.appearTime = 1;
    popup.disappearTime = 1;
    [popup show];
}

- (void)nxm_make_exit{
    
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    
    model.titleTopPadding = 15;
    model.contentLeftRightPadding = 20;
    model.titleBottomPadding = 10;
    model.buttonTopPadding = 15;
//    model.buttonSpacing = 10;
    model.buttonHeight = 44;
//    model.buttonBottomPadding = 10;
    model.title = @"退出登录";
    model.content = @"退出登录后不会删除任何历史数据\n下次登录依然可使用";

    model.cancelButtonTitle = @"取消";
    model.otherButtonTitle = @"退出";
    
    ZHHAlertViewController * popup = [[ZHHAlertViewController alloc] initWithModel:model];

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
    
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    
    model.titleTopPadding = 25;
//    model.contentLeftRightPadding = 20;
    model.titleBottomPadding = 15;
    model.buttonSpacing = 10;
    model.buttonHeight = 40;
    model.buttonBottomPadding = 20;
    model.buttonLeftRightPadding = 20;
    model.buttonTopPadding = 20;
    model.title = @"退出登录";
    model.content = @"退出登录后不会删除任何历史数据\n下次登录依然可使用";

    model.cancelButtonTitle = @"取消";
    model.otherButtonTitle = @"退出";
    
    ZHHAlertViewController * popup = [[ZHHAlertViewController alloc] initWithModel:model];

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
    ZHHAlertAppearance *model = [[ZHHAlertAppearance alloc] init];
    model.title = @"一篇短文";
    model.content = @"秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。夕阳的余晖洒在静谧的湖面上，湖水波光粼粼，犹如无数颗璀璨的星星闪耀。天空中，几只归巢的鸟儿划过天际，鸣叫声在空旷的原野中回荡。远处的山峦笼罩在薄薄的雾气中，仿佛披上了一层神秘的面纱。这一刻，大自然仿佛在低声吟唱着一首古老的诗歌。那诗句里，有着草木的清香，有着流年的印记，更有着人们心中的眷恋与不舍。一阵清风吹过，湖边的芦苇轻轻摇曳，发出沙沙的声响，仿佛在低声细语。那声音轻柔而温暖，如同母亲的呢喃，抚慰着人们的心灵。夜幕渐渐降临，星星一颗颗点缀在深蓝的天幕上。此时，天地万物都进入了宁静的时刻，唯有那颗心，还在追寻着诗意的远方。在这个秋夜里，万物归于沉寂，而心中那抹不灭的诗意，却如同夜空中的星星，永远闪烁在我们心底，照亮着前行的路。";
    model.cancelButtonTitle = @"取消";
    model.otherButtonTitle = @"确定";

    model.buttonTopPadding = 5;
    ZHHAlertViewController * popup = [[ZHHAlertViewController alloc] initWithModel:model];
    [popup show];
}

@end
