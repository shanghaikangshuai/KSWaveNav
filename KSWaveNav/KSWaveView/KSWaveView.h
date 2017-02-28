//
//  KSWaveView.h
//  KSWaveNav
//
//  Created by 康帅 on 17/2/28.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSWaveView : UIView
//浪弯曲度
@property (nonatomic, assign) CGFloat waveCurvature;
//浪速
@property (nonatomic, assign) CGFloat waveSpeed;
//浪高
@property (nonatomic, assign) CGFloat waveHeight;
//实浪颜色
@property (nonatomic, strong) UIColor *realWaveColor;
//遮罩浪颜色
@property (nonatomic, strong) UIColor *maskWaveColor;

@property (nonatomic, strong) void(^KSWaveBlock)(CGFloat currentY);

-(void)stopWaveAnimation;

-(void)startWaveAnimation;

@end
