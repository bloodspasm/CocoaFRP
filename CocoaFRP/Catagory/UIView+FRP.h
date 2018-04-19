//
//  UIView+FRP.h
//  CocoaFRPDemo
//
//  Created by bloodspasm on 2018/4/16.
//  Copyright © 2018年 bloodspasm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FRP)


/**
 截屏幕

 @return UIImage
 */
- (UIImage *)frp_snapshotImage;

/**
 设置阴影

 @param color 颜色
 @param offset 偏移
 @param radius 圆角
 */
- (void)frp_setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 设置边框

 @param color 颜色
 @param width 宽度
 @param radius 圆角
 */
- (void)frp_setLayerBorder:(UIColor*)color width:(CGFloat)width radius:(CGFloat)radius ;
/**
 清除子View
 */
- (void)frp_removeAllSubviews;

/**
 当前viewController

 @return viewController
 */
- (UIViewController *)frp_viewController;
    
/**
 添加点击事件

 @param action Block
 */
- (void)frp_addClickedBlock:(void(^)(id obj))action;
@end
