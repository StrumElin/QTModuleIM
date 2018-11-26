//
//  QTIMBaseController.h
//  RIMDemo
//
//  Created by 未可知 on 2018/10/19.
//  Copyright © 2018年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTIMControlerAdaptor.h"

#import "QTIMLoadingView.h"

@protocol QTIMBaseViewControllerDelegate <NSObject>
@optional
/** sender 有可能是button、UIBarButtonItem */
- (void)leftItemEvent:(id)sender;
- (void)rightItemEvent:(id)sender;
//- (void)titleEvent:(UIView *)sender;
@end

@interface QTIMBaseController : UIViewController <QTIMBaseViewControllerDelegate, QTIMControlerAdaptor>

//动态修改设置导航栏
- (void)setLeftItemTitle:(NSString *)title;
//- (void)setLeftItemAttributedString:(NSMutableAttributedString *)attributedString;
- (void)setLeftItemImage:(UIImage *)image;

- (void)setRightItemTitle:(NSString *)title;
//- (void)setRightItemAttributedString:(NSMutableAttributedString *)attributedString;
- (void)setRightItemImage:(UIImage *)image;

//- (void)setAttributedTitle:(NSMutableAttributedString *)str;

@end


