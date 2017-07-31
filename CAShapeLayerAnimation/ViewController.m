//
//  ViewController.m
//  CAShapeLayerAnimation
//
//  Created by WangXueqi on 17/7/31.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "ViewController.h"
#import "SoundTimeView.h"
#import "SoundBottomView.h"
#import "NSString+UIColor.h"

#define K_ScreenWidth   CGRectGetWidth([[UIScreen mainScreen] bounds])// 当前屏幕宽
#define K_ScreenHeight  CGRectGetHeight([[UIScreen mainScreen] bounds])// 当前屏幕高
@interface ViewController ()
@property(nonatomic,strong)SoundTimeView * timeView;
@property(nonatomic,strong)SoundBottomView * bottomView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"录音动画";
    [self creatTimeAndAnimationView];
}

- (void)creatTimeAndAnimationView {
    
    __weak typeof (self) selfWeak = self;
    
    if (!_timeView) {
        _timeView = [[SoundTimeView alloc]initWithFrame:CGRectMake(0, 64, K_ScreenWidth, K_ScreenHeight*2/3-64)];
        _timeView.backgroundColor = [UIColor orangeColor] ;
        [self.view addSubview:_timeView];
    }
    
    if (!_bottomView) {
        _bottomView = [[SoundBottomView alloc]initWithFrame:CGRectMake(0, K_ScreenHeight*2/3, K_ScreenWidth, K_ScreenHeight/3)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        
        [_bottomView setSoundStartBlock:^(BOOL isStart) {
            if (isStart) {
                //开始
                [selfWeak.timeView startRecord];

            }else{
                //结束
                [selfWeak.timeView stopRecord];
            }
        }];
        
        [_bottomView setSoundSaveBlock:^(BOOL isSave) {
            if (isSave) {
                //保存
            }else{
                //取消
            }
        }];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
