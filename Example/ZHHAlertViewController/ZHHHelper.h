//
//  ZHHHelper.h
//  ZHHAlertViewController_Example
//
//  Created by 宁小陌 on 2022/7/27.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZHHAnneKit/ZHHUIKit.h>
#import <ZHHAlertViewController/ZHHAlertViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHHPopupModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *cancelButtonTitle;
@property (nonatomic,copy)NSString *otherButtonTitles;
@property (nonatomic,assign)BOOL isExitBtn;
@property (nonatomic,assign)BOOL isSingleBtn;
@end

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
+ (void)nxm_make_need_update:(void (^)(void))completionBlock;
+ (ZHHAlertViewController *)popupController:(ZHHPopupModel *)model;
@end

NS_ASSUME_NONNULL_END
