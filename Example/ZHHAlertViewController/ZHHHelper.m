//
//  ZHHHelper.m
//  ZHHAlertViewController_Example
//
//  Created by 宁小陌 on 2022/7/27.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "ZHHHelper.h"
#import "ZHHAlertViewController.h"
/// RGB颜色(16进制)
#define UIColorHexRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kFontSizeArialBoldMT(fontSize)  [UIFont fontWithName:@"Arial-BoldMT"        size:fontSize]
#define kFontSizeRegular(fontSize)      [UIFont fontWithName:@"PingFangSC-Regular"  size:fontSize]

@implementation ZHHHelper

+ (void)setAppearance:(ZHHAlertViewController *)alertView{
    alertView.titleLabel.textColor = UIColorHexRGB(0x1B1B1B);
    alertView.titleLabel.font = kFontSizeArialBoldMT(17);
    alertView.messageLabel.textColor = UIColorHexRGB(0xA4A4A4);
    alertView.messageLabel.font = kFontSizeRegular(15);
    [alertView.otherButton setTitleColor:UIColorHexRGB(0xF2756A) forState:UIControlStateNormal];
    [alertView.cancelButton setTitleColor:UIColorHexRGB(0x515151) forState:UIControlStateNormal];
    alertView.otherButton.titleLabel.font = kFontSizeRegular(15);
    alertView.cancelButton.titleLabel.font = kFontSizeRegular(16);
}

+ (void)nxm_make_exit{
    NSString *titleText = @"提示";
    NSString *messageText = @"账号注销提交成功";
    ZHHAlertViewController *alertView = [[ZHHAlertViewController alloc] initWithTitle:titleText message:messageText delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self setAppearance:alertView];
    alertView.titleTopPadding = 15;
    [alertView show];
    
    alertView.otherButtonAction = ^{
        
    };
}

/// 长文本提示
+ (void)nxm_make_multiple_text{
    NSString *message = @"多看绿色植物：绿色是有益于眼镜健康的颜色，因为自然界各种物体的颜色对光线的吸收和反射水平是有差异的，绿色植物不仅能减少强烈光线对眼睛产生的直接刺激，还能较大幅度地的吸收对眼睛伤害极大的紫外线。多看绿色，能使眼睛产生一种十分舒适的感觉，眼睛健康极为有益。";
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" message:message cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    
    [self setAppearance:alertView];
                
    alertView.shouldDimBackgroundWhenShowInView = YES;
    alertView.shouldDismissOnOutsideTapped = YES;
    [alertView show];
//    alertView.delegate = self;
}

/// 无标题文本提示
+ (void)nxm_make_untitled_text{
    NSString *message = @"偶尔欣赏一下窗外的景色";
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:nil message:message cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    [self setAppearance:alertView];
    [alertView show];
}

/// 单个按钮
+ (void)nxm_make_single_button{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" message:@"轻松一点，胜人一筹" cancelButtonTitle:@"好的" otherButtonTitle:nil];
    [self setAppearance:alertView];
    [alertView show];
}


/// 自定义背景颜色
+ (void)nxm_make_custom_background_color{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" message:@"轻松一点，胜人一筹" cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    
    [self setAppearance:alertView];
    alertView.backgroundColor = [UIColor purpleColor];
    alertView.separatorColor = [UIColor blackColor];
    
    [alertView show];
}

/// 自定义背景图片
+ (void)nxm_make_custom_background_image:(CGSize)size{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" message:@"轻松一点，胜人一筹" cancelButtonTitle:@"关闭" otherButtonTitle:nil];
    [self setAppearance:alertView];
    
    UIImage * image = [UIImage imageNamed:@"alert-box.png"];
    alertView.backgroundImage = image;
    alertView.hideSeperator = YES;
    alertView.customFrame = CGRectMake((size.width - image.size.width )/2, (size.height - image.size.height)/2, image.size.width, image.size.height);
    
    [alertView show];
}

/// 自定义Frame
+ (void)nxm_make_custom_frame:(CGSize)size{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" message:@"轻松一点，胜人一筹" cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    
    alertView.customFrame = CGRectMake(30, 30, 200, 200);
    alertView.appearAnimationType = ZHHAlertViewAnimationTypeNone;
    [self setAppearance:alertView];
    
    [alertView show];
}

/// 自定义View
+ (void)nxm_make_custom_view:(CGSize)size{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" message:@"轻松一点，胜人一筹" cancelButtonTitle:@"取消" otherButtonTitle:@"好的"];
    
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
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" message:@"渐隐渐显" cancelButtonTitle:@"Cancel" otherButtonTitle:@"OK"];
    
    [self setAppearance:alertView];
    alertView.appearAnimationType = ZHHAlertViewAnimationTypeFadeIn;
    alertView.disappearAnimationType = ZHHAlertViewAnimationTypeFaceOut;
    
    alertView.appearTime = 1;
    alertView.disappearTime = 1;
    
    [alertView show];
}

+ (void)nxm_make_from_left{
    ZHHAlertViewController * alertView = [[ZHHAlertViewController alloc] initWithTitle:@"提示" message:@"左边出，右边进" cancelButtonTitle:@"Cancel" otherButtonTitle:@"OK"];
    
    [self setAppearance:alertView];
    alertView.appearAnimationType = ZHHAlertViewAnimationTypeFlyLeft;
    alertView.disappearAnimationType = ZHHAlertViewAnimationTypeFlyRight;
    
    alertView.appearTime = 1;
    alertView.disappearTime = 1;
    
    [alertView show];
}
@end
