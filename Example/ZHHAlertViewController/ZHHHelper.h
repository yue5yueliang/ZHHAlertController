//
//  ZHHHelper.h
//  ZHHAlertViewController_Example
//
//  Created by 宁小陌 on 2022/7/27.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHHHelper : NSObject
/// 普通短文本提示
+ (void)nxm_make_exit;

/// 长文本提示
+ (void)nxm_make_multiple_text;
/// 无标题文本提示
+ (void)nxm_make_untitled_text;
/// 单个按钮
+ (void)nxm_make_single_button;
/// 自定义背景颜色
+ (void)nxm_make_custom_background_color;
/// 自定义背景图片
+ (void)nxm_make_custom_background_image:(CGSize)size;
/// 自定义Frame
+ (void)nxm_make_custom_frame:(CGSize)size;
/// 自定义View
+ (void)nxm_make_custom_view:(CGSize)size;
/// 渐隐渐显
+ (void)nxm_make_fade_in;
/// 左进右出
+ (void)nxm_make_from_left;
@end

NS_ASSUME_NONNULL_END
