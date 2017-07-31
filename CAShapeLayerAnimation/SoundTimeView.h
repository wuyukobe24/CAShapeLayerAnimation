//
//  SoundTimeView.h
//  VCHelper
//
//  Created by WangXueqi on 17/7/4.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundTimeView : UIView
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)NSTimer * soundTimer;

- (void)startRecord;//开始录音
- (void)stopRecord;//结束录音
@end
