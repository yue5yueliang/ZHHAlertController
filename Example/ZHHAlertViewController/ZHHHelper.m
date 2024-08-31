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

@implementation ZHHHelper

+ (void)setAppearance:(ZHHAlertViewController *)alertView{
    alertView.titleLabel.textColor = UIColor.zhh_titleColor;
    alertView.titleLabel.font = kFontSizeArialBoldMT(17);
    alertView.contentLabel.textColor = UIColor.zhh_contentColor;
    alertView.contentLabel.font = kFontSizeRegular(15);
    [alertView.otherButton setTitleColor:UIColorHexRGB(0xF2756A) forState:UIControlStateNormal];
    [alertView.cancelButton setTitleColor:UIColor.zhh_titleColor forState:UIControlStateNormal];
    alertView.otherButton.titleLabel.font = kFontSizeRegular(15);
    alertView.cancelButton.titleLabel.font = kFontSizeRegular(16);
}

/// 长文本提示
+ (void)nxm_make_multiple_text{
    NSString *content = @"多看绿色植物：绿色是有益于眼镜健康的颜色，因为自然界各种物体的颜色对光线的吸收和反射水平是有差异的，绿色植物不仅能减少强烈光线对眼睛产生的直接刺激，还能较大幅度地的吸收对眼睛伤害极大的紫外线。多看绿色，能使眼睛产生一种十分舒适的感觉，眼睛健康极为有益。";
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:content cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    
    [self setAppearance:alertView];
                
    alertView.shouldDimBackgroundWhenShowInView = YES;
    alertView.shouldDismissOnOutsideTapped = YES;
    [alertView show];
//    alertView.delegate = self;
}

/// 无标题文本提示
+ (void)nxm_make_untitled_text{
    NSString *content = @"偶尔欣赏一下窗外的景色";
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:nil content:content cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    [self setAppearance:alertView];
    [alertView show];
}

/// 单个按钮
+ (void)nxm_make_single_button{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:@"轻松一点，胜人一筹" cancelButtonTitle:@"好的" otherButtonTitle:nil];
    [self setAppearance:alertView];
    [alertView show];
}


/// 自定义背景颜色
+ (void)nxm_make_custom_background_color{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:@"轻松一点，胜人一筹" cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    
    [self setAppearance:alertView];
    alertView.backgroundColor = [UIColor purpleColor];
    alertView.separatorColor = [UIColor blackColor];
    
    [alertView show];
}

/// 自定义背景图片
+ (void)nxm_make_custom_background_image:(CGSize)size{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:@"轻松一点，胜人一筹" cancelButtonTitle:@"关闭" otherButtonTitle:nil];
    [self setAppearance:alertView];
    
    UIImage * image = [UIImage imageNamed:@"alert-box.png"];
    alertView.backgroundImage = image;
    alertView.hideSeperator = YES;
    alertView.customFrame = CGRectMake((size.width - image.size.width )/2, (size.height - image.size.height)/2, image.size.width, image.size.height);
    
    [alertView show];
}

/// 自定义Frame
+ (void)nxm_make_custom_frame:(CGSize)size{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:@"轻松一点，胜人一筹" cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    
    alertView.customFrame = CGRectMake(30, 30, 200, 200);
    alertView.appearAnimationType = ZHHAlertViewAnimationTypeNone;
    [self setAppearance:alertView];
    
    [alertView show];
}

/// 自定义View
+ (void)nxm_make_custom_view:(CGSize)size{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:@"轻松一点，胜人一筹" cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    contentView.backgroundColor = [UIColor yellowColor];
    alertView.contentView = contentView;
    [self setAppearance:alertView];
    [alertView show];
    
    alertView.cancelButtonAction = ^{
        NSLog(@"Cancel Clicked");
    };
    
    alertView.otherButtonAction = ^{
        NSLog(@"OK Clicked");
    };
}

+ (void)nxm_make_fade_in{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:@"渐隐渐显" cancelButtonTitle:@"Cancel" otherButtonTitle:@"OK"];
    
    [self setAppearance:alertView];
    alertView.appearAnimationType = ZHHAlertViewAnimationTypeFadeIn;
    alertView.disappearAnimationType = ZHHAlertViewAnimationTypeFadeOut;
    
    alertView.appearTime = 1;
    alertView.disappearTime = 1;
    
    [alertView show];
}

+ (void)nxm_make_from_left{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" content:@"左边出，右边进" cancelButtonTitle:@"Cancel" otherButtonTitle:@"OK"];
    
    [self setAppearance:alertView];
    alertView.appearAnimationType = ZHHAlertViewAnimationTypeFlyLeft;
    alertView.disappearAnimationType = ZHHAlertViewAnimationTypeFlyRight;
    
    alertView.appearTime = 1;
    alertView.disappearTime = 1;
    
    [alertView show];
}

+ (void)nxm_make_exit{
    ZHHPopupModel *model = [[ZHHPopupModel alloc] init];
    model.title = @"退出登录";
    model.content = @"退出登录后不会删除任何历史数据\n下次登录依然可使用";
    model.cancelButtonTitle = @"取消";
    model.otherButtonTitles = @"退出";
    model.isExitBtn = YES;
    
    ZHHAlertViewController * alertView = [self popupController:model];
    alertView.otherButtonAction = ^{
        
    };
}

+ (void)nxm_make_need_update:(void (^)(void))completionBlock{
    ZHHPopupModel *model = [[ZHHPopupModel alloc] init];
    model.title = @"一篇短文";
    model.content = @"秋天的风轻轻拂过，带着一丝微凉，拂落了树梢上最后一片金黄的叶子。那叶子在空中悠悠地旋转，仿佛在和大地做最后的告别。它曾在春日里伴随着嫩芽一同生长，在夏日里享受着阳光的温暖，而今，它完成了它的使命，带着满满的回忆，归于尘土。夕阳的余晖洒在静谧的湖面上，湖水波光粼粼，犹如无数颗璀璨的星星闪耀。天空中，几只归巢的鸟儿划过天际，鸣叫声在空旷的原野中回荡。远处的山峦笼罩在薄薄的雾气中，仿佛披上了一层神秘的面纱。这一刻，大自然仿佛在低声吟唱着一首古老的诗歌。那诗句里，有着草木的清香，有着流年的印记，更有着人们心中的眷恋与不舍。一阵清风吹过，湖边的芦苇轻轻摇曳，发出沙沙的声响，仿佛在低声细语。那声音轻柔而温暖，如同母亲的呢喃，抚慰着人们的心灵。夜幕渐渐降临，星星一颗颗点缀在深蓝的天幕上。此时，天地万物都进入了宁静的时刻，唯有那颗心，还在追寻着诗意的远方。在这个秋夜里，万物归于沉寂，而心中那抹不灭的诗意，却如同夜空中的星星，永远闪烁在我们心底，照亮着前行的路。";
    model.cancelButtonTitle = @"取消";
    model.otherButtonTitles = @"确定";

    ZHHAlertViewController * alertView = [self popupController:model];
    alertView.otherButtonAction = ^{
        completionBlock();
    };
}

+ (ZHHAlertViewController *)popupController:(ZHHPopupModel *)model {
    ZHHAlertViewController * popupController = [[ZHHAlertViewController alloc] initWithTitle:model.title
                                                                                     content:model.content
                                                                                    delegate:self
                                                                           cancelButtonTitle:model.cancelButtonTitle
                                                                           otherButtonTitles:model.otherButtonTitles,nil];
    popupController.titleLabel.textColor = UIColor.zhh_titleColor;
    popupController.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
    popupController.contentLabel.textColor = UIColor.zhh_contentColor;
    popupController.contentLabel.textAlignment = NSTextAlignmentLeft;
    popupController.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [popupController.otherButton setTitleColor:UIColor.zhh_titleColor forState:UIControlStateNormal];
    [popupController.cancelButton setTitleColor:UIColor.zhh_titleColor forState:UIControlStateNormal];
    popupController.otherButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium"  size:15];
    popupController.cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium"  size:15];
    popupController.titleTopPadding = 15;
    popupController.buttonHeight = 40;
    popupController.hideSeperator = YES;
    [popupController show];
    
    if (model.isExitBtn) {
        [popupController.otherButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [popupController.otherButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColor.zhh_textColorF55B63] forState:UIControlStateNormal];
        [popupController.otherButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColorHexRGB(0xF5474F)] forState:UIControlStateHighlighted];
    }else{
        [popupController.otherButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColor.zhh_enableBtnColor] forState:UIControlStateNormal];
        [popupController.otherButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColor.zhh_highlightBtnColor] forState:UIControlStateHighlighted];
    }
    
    [popupController.cancelButton setBackgroundImage:[UIImage zhh_imageWithColor:UIColor.zhh_textColorF8F7F7] forState:UIControlStateNormal];
    [popupController.otherButton zhh_setCornerRadius:8.f];
    [popupController.cancelButton zhh_setCornerRadius:8.f];
    
    
    CGFloat width = CGRectGetWidth(popupController.frame);
    CGFloat height = CGRectGetHeight(popupController.frame);
    
    /// 按钮边距
    CGFloat margin = 20;
    /// 两个按钮之间的间距
    CGFloat padding = 12;
    /// 增加的宽度
    CGFloat addWidth = 14;
    
    /// 重新设置alertView的宽高
    popupController.zhh_y = popupController.zhh_y - margin;
    popupController.zhh_x = popupController.zhh_x - addWidth / 2;
    popupController.zhh_width = popupController.zhh_width + addWidth;
    popupController.zhh_height =  height + margin;
    
    
    /// 重新获取alertView宽度
    width = CGRectGetWidth(popupController.frame);
    
    CGFloat titleW = width - margin * 2;
    popupController.titleLabel.zhh_width = titleW;
    popupController.contentLabel.zhh_width = titleW;
    
    if (model.title.length == 0) {
        popupController.scrollView.zhh_top = 40;
    }
    
    /// 按钮宽度
    CGFloat buttonW = (width - margin * 2 - padding) / 2;
    
    /// 重置左边按钮位置
    popupController.cancelButton.zhh_left = margin;
    popupController.cancelButton.zhh_width = buttonW;
    
    if (model.isSingleBtn) {
        /// 为一个按钮的时候
        popupController.otherButton.zhh_left = margin;
        popupController.otherButton.zhh_width = titleW;
    }else{
        /// 重置右边按钮位置
        popupController.otherButton.zhh_left = popupController.cancelButton.zhh_right + padding;
        popupController.otherButton.zhh_width = buttonW;
    }
    
    return popupController;
}
@end
