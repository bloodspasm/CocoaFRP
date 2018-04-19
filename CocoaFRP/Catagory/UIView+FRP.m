//
//  UIView+FRP.m
//  CocoaFRPDemo
//
//  Created by bloodspasm on 2018/4/16.
//  Copyright © 2018年 bloodspasm. All rights reserved.
//

#import "UIView+FRP.h"
#import <objc/message.h>

@implementation UIView (FRP)


- (UIImage *)frp_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (void)frp_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)frp_setLayerBorder:(UIColor*)color width:(CGFloat)width radius:(CGFloat)radius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
}

- (void)frp_removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}


- (UIViewController *)frp_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

/***************************************************/
- (void)setClickedAction:(void (^)(id))clickedAction{
    objc_setAssociatedObject(self, @"AddClickedEvent", clickedAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id))clickedAction{
    return objc_getAssociatedObject(self, @"AddClickedEvent");
}

- (void)frp_addClickedBlock:(void(^)(id obj))clickedAction{
    self.clickedAction = clickedAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tap{
    if (self.clickedAction) {
        self.clickedAction(self);
    }
}
/***************************************************/
@end
