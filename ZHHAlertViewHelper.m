//
//  ZHHAlertViewHelper.m
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHAlertViewHelper.h"

@implementation ZHHAlertViewHelper

+ (CGFloat)heightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    if (text.length == 0 || !font) return 0;

    // 设置段落样式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = lineSpacing;

    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: style
    };

    // 计算文本的最大尺寸
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);

    // 使用 boundingRectWithSize 来计算文本的实际显示区域高度
    CGRect rect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];

    // 如果需要的话，额外考虑文本行间距对高度的影响
    CGFloat totalHeight = ceil(rect.size.height);
    NSLog(@"totalHeight -- %f",totalHeight);
    return totalHeight;
}

+ (BOOL)isStringEmpty:(NSString *)string {
    return (string == nil || ![string isKindOfClass:[NSString class]] || string.length == 0);
}

+ (NSString *)safeString:(NSString * _Nullable)string {
    return string ?: @"";
}

#pragma mark - 私有方法

// 获取当前的 keyWindow
+ (UIWindow *)keyWindow {
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive &&
            [scene isKindOfClass:[UIWindowScene class]]) {
            return scene.windows.firstObject;
        }
    }
    return nil;
}

// 为按钮添加点击高亮效果
+ (void)applyHighlightEffectToButton:(UIButton *)button {
    // 添加点击高亮效果：设置背景颜色透明度为 0.1，并在 0.2 秒后还原
    UIColor *originColor = [button.backgroundColor colorWithAlphaComponent:0];
    button.backgroundColor = [button.backgroundColor colorWithAlphaComponent:0.1];

    // 延时恢复原始颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.backgroundColor = originColor;
    });
}

+ (UIImage *)imageNamed:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
