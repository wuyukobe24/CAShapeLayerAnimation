//
//  SoundBottomView.m
//  VCHelper
//
//  Created by WangXueqi on 17/7/4.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "SoundBottomView.h"
#import "NSString+UIColor.h"

#define k_butWidth 42
#define k_soundWidth 79
#define K_ScreenWidth   CGRectGetWidth([[UIScreen mainScreen] bounds])// 当前屏幕宽
#define K_ScreenHeight  CGRectGetHeight([[UIScreen mainScreen] bounds])// 当前屏幕高
@implementation SoundBottomView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self creatBottomButtonView];
    }
    return self;
}

- (void)creatBottomButtonView {

    NSInteger H = self.frame.size.height;
    
    if (!_cancelButton) {
        _cancelButton = [self addButton:_cancelButton andFrame:CGRectMake(K_ScreenWidth/7, (H-k_butWidth)/2, k_butWidth, k_butWidth) andNormalImage:@"record_cancel" andSelectImage:nil andTitle:nil andFont:12 andNormalTitleColor:nil andSelectTitleColor:nil andAddView:self];
    }
    
    if (!_soundButton) {
        _soundButton = [self addButton:_soundButton andFrame:CGRectMake((K_ScreenWidth-k_soundWidth)/2, (H-k_soundWidth)/2, k_soundWidth, k_soundWidth) andNormalImage:@"record_start" andSelectImage:@"record_end" andTitle:nil andFont:12 andNormalTitleColor:nil andSelectTitleColor:nil andAddView:self];
    }
    
    if (!_saveButton) {
        _saveButton = [self addButton:_saveButton andFrame:CGRectMake(K_ScreenWidth*6/7-k_butWidth, (H-k_butWidth)/2, k_butWidth, k_butWidth) andNormalImage:@"record_complete" andSelectImage:nil andTitle:nil andFont:12 andNormalTitleColor:nil andSelectTitleColor:nil andAddView:self];
    }
    
    [_cancelButton addTarget:self action:@selector(soundCancelOrSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    [_soundButton addTarget:self action:@selector(soundIndexClick:) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton addTarget:self action:@selector(soundCancelOrSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//开始和结束录音
- (void)soundIndexClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    if (sender.selected) {
        //开始
        if (_soundStartBlock) {
            _soundStartBlock(YES);
        }
    }else{
        //结束
        if (_soundStartBlock) {
            _soundStartBlock(NO);
        }
    }
}

//取消和保存
- (void)soundCancelOrSaveClick:(UIButton *)sender {

    if (sender == _cancelButton) {
        
        //取消
        if (_soundSaveBlock) {
            _soundSaveBlock(NO);
        }
    }else if (sender == _saveButton) {
    
        //保存
        if (_soundSaveBlock) {
            _soundSaveBlock(YES);
        }
    }
}

-(UIButton *)addButton:(UIButton *)button
              andFrame:(CGRect)frame
        andNormalImage:(NSString *)normalImage
        andSelectImage:(NSString *)selectImage
              andTitle:(NSString *)title
               andFont:(NSInteger)font
   andNormalTitleColor:(UIColor *)normalColor
   andSelectTitleColor:(UIColor *)selectColor
            andAddView:(UIView *)subView{
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:selectColor forState:UIControlStateSelected];
    [subView addSubview:button];
    
    return button;
}

@end
