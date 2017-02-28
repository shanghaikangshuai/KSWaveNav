//
//  ViewController.m
//  KSWaveNav
//
//  Created by 康帅 on 17/2/28.
//  Copyright © 2017年 Bujiaxinxi. All rights reserved.
//

#import "ViewController.h"
#import "KSWaveView.h"

@interface ViewController ()
@property (nonatomic, strong) KSWaveView *headerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"亲友圈";
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.headerView];
    [self.navigationController.navigationBar sendSubviewToBack:self.headerView];
}

-(KSWaveView *)headerView{
    if (!_headerView) {
        _headerView=[[KSWaveView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 64)];
        _headerView.backgroundColor = [self colorWithHexString:@"#43cea2"];
        _headerView.KSWaveBlock = ^(CGFloat currentY){
        };
        [_headerView startWaveAnimation];
    }
    return _headerView;
}

-(UIColor *)colorWithHexString:(NSString *)string{
    unsigned rgbValue = 0;
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanHexInt:&rgbValue];
    return [self colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:1];
}

-(UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
