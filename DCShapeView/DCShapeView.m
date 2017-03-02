//
//  ShapeView.m
//  ShapeView iOS
//
//  Created by XDChang on 17/3/1.
//  Copyright © 2017年 XDChang. All rights reserved.
//

#import "DCShapeView.h"
#define WIDTH self.frame.size.width
#define TITLE @[@"1期",@"2期",@"3期",@"6期",@"9期",@"12期"];
@interface DCShapeView ()


@property (nonatomic,strong) NSMutableArray *btnArr; // 创建的btn
@property (nonatomic,strong) NSMutableArray *btnOriginXArr;// 每个btn的X坐标
@property (nonatomic,strong) NSMutableArray *btnLayerArr; // 多个圆的绿色layer
@property (nonatomic,strong) NSMutableArray *titleLabelArr; // 标题label数组
@property (nonatomic,assign) float xx; // 圆心系数X
@property (nonatomic,assign) float yy; // 圆心系数Y
@property (nonatomic,assign) float middleGap;//圆之间的中点系数
@end

@implementation DCShapeView
{
    
    UIView *_holeShapeView; // 底层灰色背景view
    UIImageView *_targetView; // 大按钮
    UIBezierPath *_recPath; // 创建绿色layer的贝塞尔
    CAShapeLayer *_tubeShape; // 创建绿色layer的ShapeLayer
    CGColorRef K_CGColor; // layer的颜色
}

#pragma mark --- lazy start loading ---
- (NSMutableArray *)btnArr
{
    if (!_btnArr) {
        
        _btnArr = [[NSMutableArray alloc]init];
    }
    
    return _btnArr;
}

- (NSMutableArray *)btnOriginXArr
{
    if (!_btnOriginXArr) {
        _btnOriginXArr = [[NSMutableArray alloc]init];
    }
    return _btnOriginXArr;

}

- (NSMutableArray *)btnLayerArr
{
    if (!_btnLayerArr) {
        
        _btnLayerArr = [[NSMutableArray alloc]init];
    }
    return _btnLayerArr;

}

- (NSMutableArray *)titleLabelArr
{
    if (!_titleLabelArr) {
        
        _titleLabelArr = [[NSMutableArray alloc]init];
    }
    return _titleLabelArr;
}

#pragma mark --- lazy end loading ---


#pragma mark --- 初始化
- (instancetype)initWithFrame:(CGRect)frame WithLayerColor:(UIColor *)CGcolor
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        K_CGColor = CGcolor.CGColor;
        
        [self initFactor];
        
        [self initNewPath];
        
        [self initHoleShapeView];
        
        [self initTargetView];
        
    }
    return self;

}
#pragma mark --- 初始化各种系数
- (void)initFactor
{

    
    // 4,5
    if (WIDTH == 320-20) {
        _xx = 4.0;
        
        _yy = 35.0;
        
        _middleGap = 5.0;
    }// 6
    else if (WIDTH == 375-20)
    {
        _xx = 5.0;
        
        _yy = 40.0;
        
        _middleGap = 6.0;
        
    }// 6+
    else if (WIDTH == 414 -20)
    {
        
        _xx = 6.0;
        
        _yy = 43.0;
        
        _middleGap = 7.0;
    }



}
#pragma mark --- 初始化新路径
- (void)initNewPath
{
    _recPath = [UIBezierPath bezierPath];
    _tubeShape = [[CAShapeLayer alloc]init];
    _tubeShape.strokeColor = K_CGColor;
    _tubeShape.fillColor = K_CGColor;


}

#pragma mark --- init整个底层view
- (void)initHoleShapeView
{

    _holeShapeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    [self addSubview:_holeShapeView];
    
    [self drawWholeShape];

}
#pragma mark --- init目标视图targetView
- (void)initTargetView
{
    _targetView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -6, 22, 22)];
    _targetView.image = [UIImage imageNamed:@"target"];
    
    _targetView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *imageViewPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    
    [_targetView addGestureRecognizer:imageViewPanGesture];
    
    [self addSubview:_targetView];



}

#pragma mark --- targetView的拖拽手势
- (void)panGesture:(UIPanGestureRecognizer *)gesture
{
    CGFloat y;
    
   
    switch (gesture.state) {
            
            
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"滑动开始");
            CGRect rect = gesture.view.frame;
            y = rect.origin.y ;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            // 获得添加手势的对象
            // 获得滑动的距离  包含 x y 移动的数值
            CGPoint point  =[gesture translationInView:gesture.view];
            
            CGRect targetRect = _targetView.frame;
            
            CGFloat targetX = targetRect.origin.x;

           // 管道
            [_recPath removeAllPoints];
            [_recPath moveToPoint:CGPointMake(8, 5.8)];
            [_recPath addLineToPoint:CGPointMake(8, 7)];
            
            if (targetX>8) {
                
                [_recPath addLineToPoint:CGPointMake(targetX, 7)];
                [_recPath addLineToPoint:CGPointMake(targetX, 5.8)];
            }
            
            
           
            [_recPath closePath];
            
            _tubeShape.path = _recPath.CGPath;
            [_tubeShape setNeedsDisplay];
            [self.layer addSublayer:_tubeShape];

            
            NSArray *titleArr = TITLE;
            
            for (int i = 0; i <6; i ++) {
                
                if (i!=5) {
                    // 滑动过程中添加绿色圆layer
                    if (targetX >= [self.btnOriginXArr[i]integerValue] && targetX < [_btnOriginXArr[i+1]integerValue]) {
                        
                        CAShapeLayer *layer = self.btnLayerArr[i+1];
                        
                        if (layer) {
                            [layer removeFromSuperlayer];
                        }
                        
                        [_holeShapeView.layer addSublayer:self.btnLayerArr[i]];
                        [_shapeViewDelegate onShapeViewDelegateEventWithString:titleArr[i]];
                    }
                    
                }
                
            }
            //CGRectOffset是以试图的原点为起始 移动 dx x移动距离  dy y移动距离
            
           gesture.view.frame =CGRectOffset(gesture.view.frame, point.x, y );
            
            //清空移动距离
            [gesture setTranslation:CGPointZero inView:gesture.view];
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
//            recPath = [UIBezierPath bezierPath];
            NSLog(@"滑动结束");
            
            CGRect targetRect = _targetView.frame;
            
            CGFloat targetX = targetRect.origin.x;
            
            float btnX = [self.btnOriginXArr.lastObject integerValue];
           // targetView在第一个圆
            if (targetX<0) {
                
                targetRect.origin.x = 0;
                
                _targetView.frame = targetRect;
                
                [_shapeViewDelegate onShapeViewDelegateEventWithString:@"1期"];
                // 改变下标题颜色
                for (UILabel *label in self.titleLabelArr) {
                    
                    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                }
                UILabel *firstLabel = self.titleLabelArr.firstObject;
                
                
                firstLabel.textColor = [UIColor colorWithCGColor:K_CGColor];
                break;
            }
            // targetView在最后一个圆
            if (targetX >btnX) {
                
                targetRect.origin.x = btnX;
                
                _targetView.frame = targetRect;
                [_shapeViewDelegate onShapeViewDelegateEventWithString:@"12期"];
                // 改变下标题颜色
                for (UILabel *label in self.titleLabelArr) {
                    
                    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                }
                UILabel *firstLabel = self.titleLabelArr.lastObject;
                
                
                firstLabel.textColor = [UIColor colorWithCGColor:K_CGColor];
                break;
            }
            
            NSArray *titleArr = TITLE;
            // targetView 在中间各个圆
            for (int i = 0; i <6; i ++) {
                
                if (i!=5) {
                   
                    if (targetX >= [self.btnOriginXArr[i]integerValue] && targetX < [_btnOriginXArr[i]integerValue]+15.0 +_middleGap*i) {
                        
                        
                        NSLog(@"%ld",(long)[_btnOriginXArr[i]integerValue]);
                        
                        targetRect.origin.x = [_btnOriginXArr[i]integerValue];
                        _targetView.frame = targetRect;
                        
                        [_shapeViewDelegate onShapeViewDelegateEventWithString:titleArr[i]];
                        
                        for (UILabel *label in self.titleLabelArr) {
                            
                            label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                        }
                        UILabel *firstLabel = self.titleLabelArr[i];
                        
                        
                        firstLabel.textColor = [UIColor colorWithCGColor:K_CGColor];
                        
                        
                    }
                    else if(targetX >=[_btnOriginXArr[i]integerValue]+10.0 + _middleGap*i)
                    {
                        targetRect.origin.x = [_btnOriginXArr[i+1]integerValue];
                        _targetView.frame = targetRect;
                        [_shapeViewDelegate onShapeViewDelegateEventWithString:titleArr[i+1]];
                        
                        // 改变下标题颜色
                        for (UILabel *label in self.titleLabelArr) {
                            
                            label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                        }
                        UILabel *firstLabel = self.titleLabelArr[i+1];
                        
                        firstLabel.textColor = [UIColor colorWithCGColor:K_CGColor];
                    
                    }
                    
                }
            
            }
           // 先移除贝塞尔所有的点,然后重新绘制贝塞尔路径
            [_recPath removeAllPoints];
            [_recPath moveToPoint:CGPointMake(8, 5.8)];
            [_recPath addLineToPoint:CGPointMake(8, 7)];
            
            [_recPath addLineToPoint:CGPointMake(_targetView.frame.origin.x, 7)];
            [_recPath addLineToPoint:CGPointMake(_targetView.frame.origin.x, 5.8)];
            
            [_recPath closePath];
            
            _tubeShape.path = _recPath.CGPath;
            [_tubeShape setNeedsDisplay];
            [self.layer addSublayer:_tubeShape];
        }
            
            break;
        default:
            break;
    }



}

#pragma mark --- 加载所有的layer
- (void)drawWholeShape
{
    CGFloat gapX = self.frame.origin.x;
    // 管道
    UIBezierPath *recPath = [UIBezierPath bezierPath];
    
    [recPath moveToPoint:CGPointMake(8, 4)];
    [recPath addLineToPoint:CGPointMake(8, 8)];
    [recPath addLineToPoint:CGPointMake(8+WIDTH-2*gapX, 8)];
    [recPath addLineToPoint:CGPointMake(8+WIDTH-2*gapX, 4)];
    CAShapeLayer *tubeShape = [[CAShapeLayer alloc]init];
    
    tubeShape.path = recPath.CGPath;
    tubeShape.strokeColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
    tubeShape.fillColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
    
    
     [_holeShapeView.layer addSublayer:tubeShape];
    
    NSArray *title = TITLE;
    
    for (int i = 0; i <6; i ++) {
        
        // 圆形
        UIBezierPath *leftSemiPath1 = [UIBezierPath bezierPath];
        
        CGPoint pointR1 = CGPointMake(12 +(_yy+_xx*i)*i, 6);
        
        [leftSemiPath1 addArcWithCenter:pointR1 radius:6 startAngle:(0.0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
        
        
        CAShapeLayer *leftSemiShape1 = [[CAShapeLayer alloc]init];
        
        leftSemiShape1.path = leftSemiPath1.CGPath;
        
        leftSemiShape1.strokeColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
        leftSemiShape1.fillColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;

        [_holeShapeView.layer addSublayer:leftSemiShape1];
        
        
        // 圆形2
        UIBezierPath *leftSemiPath2 = [UIBezierPath bezierPath];
        
        CGPoint pointR2 = CGPointMake(12 +(_yy+_xx*i)*i, 6);
        
        [leftSemiPath2 addArcWithCenter:pointR2 radius:4 startAngle:(0.0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
        
        
        CAShapeLayer *leftSemiShape2 = [[CAShapeLayer alloc]init];
        
        leftSemiShape2.path = leftSemiPath2.CGPath;
        
        leftSemiShape2.strokeColor = K_CGColor;
        leftSemiShape2.fillColor = K_CGColor;

        [self.btnLayerArr addObject:leftSemiShape2];
        
        if (i==0) {
           
            
            [_holeShapeView.layer addSublayer:leftSemiShape2];
        }
        
        float x = 4 +(_yy+_xx*i)*i;
        
        UIButton *stepBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, -2, 14, 14)];
        
        [_btnArr addObject:stepBtn];
        [self.btnOriginXArr addObject:@(x)];
        
        stepBtn.tag = i;
        
        [stepBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:stepBtn];
        
        
        UILabel *qiShuLabel = [[UILabel alloc]init];
        
        qiShuLabel.center = CGPointMake(x-4, 20);
        qiShuLabel.text = title[i];
        qiShuLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        qiShuLabel.font = [UIFont systemFontOfSize:12];
        
        [qiShuLabel sizeToFit];
        
        [self addSubview:qiShuLabel];
        
        [self.titleLabelArr addObject:qiShuLabel];
    }
   
}

#pragma mark --- 按钮点击事件
- (void)onBtnClick:(UIButton *)btn
{
    NSArray *titleArr = TITLE;
    
    [_shapeViewDelegate onShapeViewDelegateEventWithString:titleArr[btn.tag]];
    

    [UIView animateWithDuration:0.3 animations:^{
        
        NSInteger x = [_btnOriginXArr[btn.tag]integerValue];
        CGRect rect = _targetView.frame;
        rect.origin.x = x;
        _targetView.frame = rect;
        
       

    } completion:^(BOOL finished) {
        // 改变下标题颜色
        for (UILabel *label in self.titleLabelArr) {
            
            label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        }
        UILabel *firstLabel = self.titleLabelArr[btn.tag];
        
        firstLabel.textColor = [UIColor colorWithCGColor:K_CGColor];
    }];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        for (CAShapeLayer *layer in self.btnLayerArr) {
            
            [layer removeFromSuperlayer];
        }
        
        for (int i = 0; i < btn.tag+1; i ++) {
            
            
            [_holeShapeView.layer addSublayer:self.btnLayerArr[i]];
            
        }
        // 先移除贝塞尔所有的点,然后重新绘制贝塞尔路径
        [_recPath removeAllPoints];
        [_recPath moveToPoint:CGPointMake(8, 5.8)];
        [_recPath addLineToPoint:CGPointMake(8, 7)];
        
        if (_targetView.frame.origin.x > 8) {
            
            [_recPath addLineToPoint:CGPointMake(_targetView.frame.origin.x, 7)];
            [_recPath addLineToPoint:CGPointMake(_targetView.frame.origin.x, 5.8)];
            
        }
        
        
        [_recPath closePath];
        
        _tubeShape.path = _recPath.CGPath;
        [_tubeShape setNeedsDisplay];
        [self.layer addSublayer:_tubeShape];
        
        
        
    });
    
    
    

}



@end
