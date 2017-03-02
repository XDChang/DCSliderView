//
//  ViewController.m
//  DCShapeView
//
//  Created by XDChang on 17/3/2.
//  Copyright © 2017年 XDChang. All rights reserved.
//

#import "ViewController.h"
#import "DCShapeView.h"
@interface ViewController ()<ShapeViewDelegate>

{
    
    UIView *_holeShapeView;
    UILabel *_qiShuLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.
    DCShapeView *shapeView = [[DCShapeView alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width -20, 30) WithLayerColor:[UIColor colorWithRed:0/255.0 green:210/255.0 blue:87/255.0 alpha:1]];
    
    // 2.
    shapeView.shapeViewDelegate = self;
    
    //3.
    [self.view addSubview:shapeView];
    
    
    _qiShuLabel = [[UILabel alloc]init];
    
    _qiShuLabel.center = CGPointMake(self.view.frame.size.width/2-30, 160);
    
    _qiShuLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    
    _qiShuLabel.font = [UIFont systemFontOfSize:14];
    
    _qiShuLabel.text = @"1期" ;
    [_qiShuLabel sizeToFit];
    
    [self.view addSubview:_qiShuLabel];
    
}
// 4.
- (void)onShapeViewDelegateEventWithString:(NSString *)str
{
    
    _qiShuLabel.text = str ;
    [_qiShuLabel sizeToFit];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
