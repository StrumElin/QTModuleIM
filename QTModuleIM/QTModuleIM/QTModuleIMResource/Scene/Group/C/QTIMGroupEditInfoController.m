//
//  QTIMGroupEditInfoController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/21.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupEditInfoController.h"

@interface QTIMGroupEditInfoController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) QTIMGroupEditInfoViewModel *viewMode;
@end

@implementation QTIMGroupEditInfoController
- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel]) {
        _viewMode = (QTIMGroupEditInfoViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.text = self.viewMode.name;
    [self setupRightBarWithEnable:NO];
    @weakify(self);
    [[_textField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self setupRightBarWithEnable:self.textField.text.length != 0];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupRightBarWithEnable:(BOOL)enable
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:nil action:@selector(didClickRightBar:)];
    item.enabled = enable;
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didClickRightBar:(id)sender
{
    @weakify(self);
    [[self.viewMode updateGroupInfoWithName:self.textField.text] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
//        [self updateGroupInfoPage:self.textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError * _Nullable error) {
        
    }];
}

//- (void)updateGroupInfoPage:(NSString *)name{};


@end
