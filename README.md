# CAShapeLayerAnimation

//设置正弦波浪

    self.waveSinLayer = [CAShapeLayer layer];
    _waveSinLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.waveSinLayer.fillColor = [[UIColor greenColor] CGColor];
    self.waveSinLayer.frame = CGRectMake(0, imageView.bounds.size.height, imageView.bounds.size.width, imageView.bounds.size.height);
 
    self.waveHeight = CGRectGetHeight(imageView.bounds)/2;//设置波浪大小
    self.waveWidth  = CGRectGetWidth(imageView.bounds);
    self.frequency = 1;
    self.phaseShift = 8;
    self.waveMid = self.waveWidth*2;
    self.maxAmplitude = self.waveHeight*.1f;
    
    _sineImageView = [[UIImageView alloc] initWithFrame:imageView.bounds];
    _sineImageView.image = [UIImage imageNamed:@"sound_blue-water"];
    [imageView addSubview:_sineImageView];
    
    _sineImageView.layer.mask = _waveSinLayer;
 
 //开始动画特效
 
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
    
 波浪动画截图：
 
![image](https://github.com/wuyukobe24/CAShapeLayerAnimation/blob/master/recordAnimation.png)
