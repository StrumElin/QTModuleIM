//
//  QTIMLoadingView.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/24.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMLoadingView.h"

#import "QTIMMacros.h"

static QTIMLoadingView *loadingView;

@interface QTIMLoadingView ()
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation QTIMLoadingView

+ (instancetype)show
{
    return [self showInView:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)showInView:(UIView *)inView
{
    return [self showInView:inView userInteractionEnable:NO];
}

+ (instancetype)showInView:(UIView *)inView userInteractionEnable:(BOOL)userInteractionEnable
{
    if (!loadingView) {
        loadingView = [[QTIMLoadingView alloc] init];
        loadingView.backgroundColor = QTIMHEXCOLORAlpha(0xffffff, 0);
        loadingView.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.indicatorView.hidesWhenStopped = YES;
        [loadingView addSubview:loadingView.indicatorView];
    }
    if (userInteractionEnable) {
        loadingView.bounds = CGRectMake(0, 0, 20, 20);
        loadingView.center = CGPointMake(inView.frame.size.width/2, inView.frame.size.height/2);
    }
    else {
        loadingView.frame = CGRectMake(0, 0, inView.frame.size.width, inView.frame.size.height);
    }
    loadingView.indicatorView.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
    [loadingView.indicatorView startAnimating];
    [inView addSubview:loadingView];
    return loadingView;
}

+ (void)hide
{
    [loadingView.indicatorView stopAnimating];
    [loadingView removeFromSuperview];
}
@end
