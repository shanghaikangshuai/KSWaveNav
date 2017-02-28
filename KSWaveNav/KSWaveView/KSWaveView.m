//
//  KSWaveView.m
//  KSWaveNav
//
//  Created by 康帅 on 17/2/28.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "KSWaveView.h"

@interface KSProxy:NSObject

@property(strong,nonatomic)id executor;

@end

@implementation KSProxy
-(void)callback{
    //让编译器忽视这个警告而已
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [_executor performSelector:@selector(Wave)];
#pragma clang diagnostic pop
}
@end

@interface KSWaveView()
//真实浪
@property (nonatomic, strong) CAShapeLayer *realWaveLayer;
//遮罩浪
@property (nonatomic, strong) CAShapeLayer *maskWaveLayer;
//每帧刷新
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat offset;
@end

@implementation KSWaveView
/*
 ** 构造方法
 */
-(instancetype)init{
    self=[super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
/*
 ** 初始化参数
 */
-(void)commonInit{
    self.waveSpeed = 1.8;
    self.waveCurvature = 1.5;
    self.waveHeight = 6;
    self.realWaveColor = [UIColor whiteColor];
    self.maskWaveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    
    [self.layer addSublayer:self.realWaveLayer];
    [self.layer addSublayer:self.maskWaveLayer];
}

-(void)stopWaveAnimation{
    [self.displayLink invalidate];
    self.displayLink=nil;
}

-(void)startWaveAnimation{
    KSProxy *proxy=[[KSProxy alloc]init];
    proxy.executor=self;
    self.displayLink=[CADisplayLink displayLinkWithTarget:proxy selector:@selector(callback)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)Wave{
    self.offset+=self.waveSpeed;
    
    CGFloat width=CGRectGetWidth(self.frame);
    CGFloat height=self.waveHeight;
    
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height);
    CGFloat y=0.f;
    
    CGMutablePathRef maskpath=CGPathCreateMutable();
    CGPathMoveToPoint(maskpath, NULL, 0, height);
    CGFloat masky=0.f;
    
    for (CGFloat x=0.f; x<width; x++) {
        y=height*sinf(0.01*self.waveCurvature*x+self.offset*0.045);
        CGPathAddLineToPoint(path, NULL, x, y);
        masky=-y;
        CGPathAddLineToPoint(maskpath, NULL, x, masky);
    }
    
    CGFloat centX=self.bounds.size.width/2;
    CGFloat centY=height*sinf(0.01*self.waveCurvature*centX+self.offset*0.045);
    if (_KSWaveBlock) {
        _KSWaveBlock(centY);
    }
    
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.realWaveLayer.path=path;
    self.realWaveLayer.fillColor=self.realWaveColor.CGColor;
    CGPathRelease(path);
    
    CGPathAddLineToPoint(maskpath, NULL, width, height);
    CGPathAddLineToPoint(maskpath, NULL, 0, height);
    CGPathCloseSubpath(maskpath);
    self.maskWaveLayer.path=maskpath;
    self.maskWaveLayer.fillColor=self.maskWaveColor.CGColor;
    CGPathRelease(maskpath);
}
#pragma Setter方法
-(void)setWaveHeight:(CGFloat)waveHeight{
    _waveHeight=waveHeight;
    
    CGRect frame = [self bounds];
    frame.origin.y = frame.size.height-self.waveHeight;
    frame.size.height = self.waveHeight;
    _realWaveLayer.frame = frame;
    _maskWaveLayer.frame=frame;
}

#pragma 懒加载
-(CAShapeLayer *)realWaveLayer{
    if (!_realWaveLayer) {
        _realWaveLayer=[CAShapeLayer layer];
        CGRect frame=self.bounds;
        frame.origin.y=frame.size.height-self.waveHeight;
        frame.size.height=self.waveHeight;
        _realWaveLayer.frame=frame;
        _realWaveLayer.fillColor=self.realWaveColor.CGColor;
    }
    return _realWaveLayer;
}
-(CAShapeLayer *)maskWaveLayer{
    if (!_maskWaveLayer) {
        _maskWaveLayer=[CAShapeLayer layer];
        CGRect frame=self.bounds;
        frame.origin.y=frame.size.height-self.waveHeight;
        frame.size.height=self.waveHeight;
        _maskWaveLayer.frame=frame;
        _maskWaveLayer.fillColor=self.maskWaveColor.CGColor;
    }
    return _maskWaveLayer;
}
@end
