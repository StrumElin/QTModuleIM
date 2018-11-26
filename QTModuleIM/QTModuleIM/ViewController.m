//
//  ViewController.m
//  QTModuleIM
//
//  Created by ☺strum☺ on 2018/11/26.
//  Copyright © 2018年 l. All rights reserved.
//

#import "ViewController.h"
#import "QTIMLoginController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginPage:(id)sender {
    QTIMLoginController *lg = [[QTIMLoginController alloc] initWithNibName:@"QTIMLoginController" bundle:nil];
    [self.navigationController pushViewController:lg animated:YES];
}

@end
