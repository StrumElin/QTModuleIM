//
//  QTIMBaseController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/10/19.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "QTIMBaseController.h"

#import "QTIMMacros.h"

#import "NSString+QTIM.h"
#import "UIImage+QTIM.h"

@interface QTIMBaseController ()

@end

@implementation QTIMBaseController

- (void)dealloc
{
    QTINFOLog(@"%@ dealloc",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setLeftItemImage:[[UIImage imageNamed:@"back"] imageByScalingToSize:CGSizeMake(20, 20)]];
}

- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super init]) {
        //TODO:
    }
    return self;
}

#pragma mark - NavigationBar
//设置导航栏
- (void)setLeftItemTitle:(NSString *)title
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(left_click:)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}

//- (void)setLeftItemAttributedString:(NSMutableAttributedString *)attributedString
//{
//    NSRange range = NSMakeRange(0, attributedString.length);
//    UIFont *font = [attributedString attributesAtIndex:0 effectiveRange:&range][NSFontAttributeName];
//    CGFloat fontSize = [[font.fontDescriptor objectForKey:UIFontDescriptorSizeAttribute] floatValue];
//    CGFloat w = [NSString getTextWidthWith:attributedString.string height:20 font:fontSize] + 3;
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, w, 44);
//    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitleColor:HEXCOLOR(0xff9900) forState:UIControlStateNormal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = item;
//}

- (void)setLeftItemImage:(UIImage *)image
{
    if (image)
    {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(left_click:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setRightItemTitle:(NSString *)title
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(right_click:)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
}

//- (void)setRightItemAttributedString:(NSMutableAttributedString *)attributedString
//{
//    NSRange range = NSMakeRange(0, attributedString.length);
//    UIFont *font = [attributedString attributesAtIndex:0 effectiveRange:&range][NSFontAttributeName];
//    CGFloat fontSize = [[font.fontDescriptor objectForKey:UIFontDescriptorSizeAttribute] floatValue];
//    CGFloat w = [attributedString.string textWidth:20 font:font] + 3;
////    CGFloat w = [NSString getTextWidthWith:attributedString.string height:20 font:fontSize] + 3;
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, w, 44);
//    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitleColor:QTIMHEXCOLOR(0xff9900) forState:UIControlStateNormal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = item;
//}

- (void)setRightItemImage:(UIImage *)image
{
    if (image)
    {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(right_click:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setAttributedTitle:(NSMutableAttributedString *)str
{
    [self set_Title:str];
}

-(void)set_Title:(NSMutableAttributedString *)title
{
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines = 1;
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    self.navigationItem.titleView = navTitleLabel;
}

//-(void)titleClick:(UIGestureRecognizer*)Tap
//{
//    UIView *view = Tap.view;
//    if ([self respondsToSelector:@selector(titleEvent:)]) {
//        [self titleEvent:view];
//    }
//}

-(void)left_click:(id)sender
{
    if ([self respondsToSelector:@selector(leftItemEvent:)]) {
        [self leftItemEvent:sender];
    }
}

-(void)right_click:(id)sender
{
    if ([self respondsToSelector:@selector(rightItemEvent:)]) {
        [self rightItemEvent:sender];
    }
}

- (void)leftItemEvent:(id)sender
{
    //可以子类重写,默认的事件是返回
    if (self.navigationController.presentedViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
