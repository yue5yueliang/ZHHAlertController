//
//  ZHHAlertViewHelper.h
//  ZHHAlertViewController
//
//  Created by 桃色三岁 on 2022/4/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHHAlertViewHelper : NSObject

/// 计算多行文本高度（可选行距）
/// @param text 文本内容
/// @param font 字体
/// @param width 限定最大宽度
/// @param lineSpacing 行距
/// @return 文本所占高度（向上取整）
+ (CGFloat)heightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

/// 判断字符串是否为空或无效
/// @param string 要判断的字符串
/// @return YES 表示为空或非法
+ (BOOL)isStringEmpty:(NSString * _Nullable)string;

/// 安全返回非空字符串（为空则返回 @""）
/// @param string 原始字符串
/// @return 非空字符串
+ (NSString *)safeString:(NSString * _Nullable)string;

/// 获取当前活跃窗口（keyWindow）
/// @return 当前应用场景下的主窗口
+ (UIWindow * _Nullable)keyWindow;

/// 为按钮添加轻触高亮效果（背景色浅变暗，稍后恢复）
/// @param button 需要处理的按钮
+ (void)applyHighlightEffectToButton:(UIButton *)button;

/// 从当前 Bundle 中加载图片
/// @param imageName 图片名称
/// @return UIImage 对象
+ (UIImage * _Nullable)imageNamed:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
