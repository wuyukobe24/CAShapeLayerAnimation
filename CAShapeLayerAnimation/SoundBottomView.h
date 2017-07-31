//
//  SoundBottomView.h
//  VCHelper
//
//  Created by WangXueqi on 17/7/4.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundBottomView : UIView
@property(nonatomic,strong)UIButton * cancelButton;
@property(nonatomic,strong)UIButton * soundButton;
@property(nonatomic,strong)UIButton * saveButton;
@property(nonatomic,copy)void(^soundStartBlock)(BOOL);
@property(nonatomic,copy)void(^soundSaveBlock)(BOOL);
@end
