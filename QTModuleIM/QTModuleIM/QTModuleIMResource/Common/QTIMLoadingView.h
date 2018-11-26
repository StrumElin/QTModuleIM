//
//  QTIMLoadingView.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/24.
//  Copyright © 2018 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTIMLoadingView : UIView
+ (instancetype)show;
+ (instancetype)showInView:(UIView *)inView;
+ (instancetype)showInView:(UIView *)inView userInteractionEnable:(BOOL)userInteractionEnable;
+ (void)hide;
@end
