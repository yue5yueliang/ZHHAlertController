//
//  ZHHAlertExample.h
//  ZHHAlertViewController_Example
//
//  Created by 桃色三岁 on 2022/7/27.
//  Copyright © 2022 桃色三岁y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZHHAnneKit/ZHHUIKit.h>
#import <ZHHAlertViewController/ZHHAlertViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZHHColors)
/// 标题文字颜色
+ (instancetype)zhh_titleColor;
/// 副标题文字颜色
+ (instancetype)zhh_subtitleColor;
/// 正文字颜色
+ (instancetype)zhh_contentColor;
/// 颜色#F55B63 rgba(245, 91, 99, 1)
+ (instancetype)zhh_textColorF55B63;
/// 按钮普通颜色
+ (instancetype)zhh_enableBtnColor;
/// 按钮选中颜色
+ (instancetype)zhh_disabledBtnColor;
/// 按钮高亮颜色
+ (instancetype)zhh_highlightBtnColor;
/// 颜色#F8F7F7
+ (instancetype)zhh_textColorF8F7F7;
@end

@interface ZHHAlertExample : NSObject

+ (instancetype)sharedInstance;

#pragma mark - 基础示例

/// 基础提示框
- (void)showBasicAlert;

/// 长文本提示（可滚动）
- (void)showLongTextAlert;

/// 无标题提示
- (void)showNoTitleAlert;

/// 只有标题提示（无内容）
- (void)showTitleOnlyAlert;

/// 单按钮提示
- (void)showSingleButtonAlert;

#pragma mark - 样式自定义

/// 自定义按钮样式
- (void)showCustomButtonStyle;

/// 自定义背景颜色
- (void)showCustomBackgroundColor;

/// 自定义尺寸
- (void)showCustomSize;

/// 自定义圆角
- (void)showCustomCornerRadius;

/// 按钮位置调整（取消按钮在右侧）
- (void)showButtonPositionRight;

#pragma mark - 动画示例

/// 默认动画
- (void)showDefaultAnimation;

#pragma mark - 交互行为

/// 点击外部关闭
- (void)showDismissOnOutsideTap;

/// 点击按钮不自动关闭
- (void)showNoAutoDismiss;

/// 在指定视图中显示
- (void)showInCustomView;

#pragma mark - 自定义视图

/// 自定义内容视图
- (void)showCustomContentView;

/// 使用代理回调
- (void)showWithDelegate;

/// 使用 Block 回调
- (void)showWithBlockCallback;

@end

NS_ASSUME_NONNULL_END
