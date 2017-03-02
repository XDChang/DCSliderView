//
//  ShapeView.h
//  DCShapeView iOS
//
//  Created by XDChang on 17/3/1.
//  Copyright © 2017年 XDChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DCSliderView : UIView

/*!
 @property shapeViewDelegate
 @abstract DCShapeView的代理
 */
@property (nonatomic,assign) id shapeViewDelegate;

/*!
 @method  DCShapeView初始化方法。
 @abstract DCShapeView初始化方法。
 @discussion DCShapeView初始化方法,设置frame跟layer的颜色。
 @param frame DCShapeView frame
 @param CGcolor DCShapeView layer颜色

 */
- (instancetype)initWithFrame:(CGRect)frame WithLayerColor:(UIColor *)CGcolor;
@end


@protocol ShapeViewDelegate <NSObject>

/*!
 @method  DCShapeView代理方法。
 @param str 返回下标题
 */
- (void)onShapeViewDelegateEventWithString:(NSString *)str;

@end

