//
//  SoundTimeView.m
//  VCHelper
//
//  Created by WangXueqi on 17/7/4.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "SoundTimeView.h"
#import "NSString+UIColor.h"
#define K_ScreenWidth   CGRectGetWidth([[UIScreen mainScreen] bounds])// 当前屏幕宽
#define K_ScreenHeight  CGRectGetHeight([[UIScreen mainScreen] bounds])// 当前屏幕高
typedef NS_ENUM(NSInteger, WavePathType) {

    WavePathType_Sin,
    WavePathType_Cos
};

@interface SoundTimeView()

@property (nonatomic, assign) CGFloat frequency;//频率
@property (nonatomic, strong) UIImageView * grayImageView;
@property (nonatomic, strong) UIImageView * sineImageView;
@property (nonatomic, strong) UIImageView * cosineImageView;
@property (nonatomic, strong) CAShapeLayer * waveSinLayer;
@property (nonatomic, strong) CAShapeLayer * waveCosLayer;
@property (nonatomic, strong) CADisplayLink * displayLink;
//波浪相关的参数
@property (nonatomic, assign) CGFloat waveWidth;
@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat waveMid;
@property (nonatomic, assign) CGFloat maxAmplitude;//最大振幅
@property (nonatomic, assign) CGFloat phaseShift;//相位变化
@property (nonatomic, assign) CGFloat phase;

@end

static CGFloat kWavePositionDuration = 10;//完成一次时间
@implementation SoundTimeView
{

    UIView * imageView;
    NSInteger minute;
    NSInteger second;
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self creatSoundTimeView];
    }
    return self;
}

- (void)creatSoundTimeView {

    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, K_ScreenWidth, 40)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:36];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.text = @"00:00";
    [self addSubview:_timeLabel];
    
    imageView = [[UIView alloc]initWithFrame:CGRectMake((K_ScreenWidth-150)/2, 80+50, 150, 150)];
    [self addSubview:imageView];
    
    self.waveSinLayer = [CAShapeLayer layer];
    _waveSinLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.waveSinLayer.fillColor = [[UIColor greenColor] CGColor];
    self.waveSinLayer.frame = CGRectMake(0, imageView.bounds.size.height, imageView.bounds.size.width, imageView.bounds.size.height);
    
    self.waveCosLayer = [CAShapeLayer layer];
    _waveCosLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.waveCosLayer.fillColor = [[UIColor blueColor] CGColor];
    self.waveCosLayer.frame = CGRectMake(0, imageView.bounds.size.height, imageView.bounds.size.width, imageView.bounds.size.height);
    
    self.waveHeight = CGRectGetHeight(imageView.bounds)/2;//设置波浪大小
    self.waveWidth  = CGRectGetWidth(imageView.bounds);
    self.frequency = 1;
    self.phaseShift = 8;
    self.waveMid = self.waveWidth*2;
    self.maxAmplitude = self.waveHeight*.1f;
    
    _grayImageView = [[UIImageView alloc] initWithFrame:imageView.bounds];
    _grayImageView.image = [UIImage imageNamed:@"sound_blue"];
    [imageView addSubview:_grayImageView];
    
    _cosineImageView = [[UIImageView alloc] initWithFrame:imageView.bounds];
//    _cosineImageView.image = [UIImage imageNamed:@"sound_ligh_blue"];
    [imageView addSubview:_cosineImageView];
    
    _sineImageView = [[UIImageView alloc] initWithFrame:imageView.bounds];
    _sineImageView.image = [UIImage imageNamed:@"sound_blue-water"];
    [imageView addSubview:_sineImageView];
    
    _sineImageView.layer.mask = _waveSinLayer;
    _cosineImageView.layer.mask = _waveCosLayer;
}

//开始录音
- (void)startRecord {

    minute = 0;
    second = 0;
    _timeLabel.text = @"00:00";
    if (!_soundTimer) {
        _soundTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    }
    
    [self startLoading];
}

//结束录音
- (void)stopRecord {

    if (_soundTimer.isValid) {
        [_soundTimer invalidate];
        _soundTimer = nil;
    }
    
    [self stopLoading];
}

//定时器刷新时间
- (void)refreshTime {

    if (minute < 3) {
       
        second++;
        if (second == 60) {
            second = 0;
            minute++;
        }
        
    }else{
    
        [self stopRecord];
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld",minute,second];
}

#pragma mark - Public Methods
- (void)startLoading {
    
    [_displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(updateWave:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];
    CGPoint position = self.waveSinLayer.position;
    position.y = position.y - imageView.bounds.size.height - 10;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:self.waveSinLayer.position];
    animation.toValue = [NSValue valueWithCGPoint:position];
    animation.duration = kWavePositionDuration;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    [self.waveSinLayer addAnimation:animation forKey:@"positionWave"];
    [self.waveCosLayer addAnimation:animation forKey:@"positionWave"];
}

- (void)stopLoading {
    
    [self.displayLink invalidate];
    [self.waveSinLayer removeAllAnimations];
    [self.waveCosLayer removeAllAnimations];
    self.waveSinLayer.path = nil;
    self.waveCosLayer.path = nil;
}

- (void)updateWave:(CADisplayLink *)displayLink {
    
    self.phase += self.phaseShift;
    self.waveSinLayer.path = [self createWavePathWithType:WavePathType_Sin].CGPath;
    self.waveCosLayer.path = [self createWavePathWithType:WavePathType_Cos].CGPath;
}

- (UIBezierPath *)createWavePathWithType:(WavePathType)pathType {
    
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    CGFloat endX = 0;
    for (CGFloat x = 0; x < self.waveWidth + 1; x += 1) {
        endX=x;
        CGFloat y = 0;
        if (pathType == WavePathType_Sin) {
            y = self.maxAmplitude * sinf(360.0 / _waveWidth * (x  * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
        } else {
            y = self.maxAmplitude * cosf(360.0 / _waveWidth *(x  * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.maxAmplitude;
        }
        
        if (x == 0) {
            [wavePath moveToPoint:CGPointMake(x, y)];
        } else {
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    CGFloat endY = CGRectGetHeight(imageView.bounds) + 10;
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    return wavePath;
}

@end
