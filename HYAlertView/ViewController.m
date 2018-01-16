//
//  ViewController.m
//  HYAlertView
//
//  Created by  huiyuan on 2018/1/16.
//  Copyright © 2018年 张宇超. All rights reserved.
//

#import "ViewController.h"
#import "HYQuizView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showAnswerQuestionAction:(UIButton *)sender {
     [[HYQuizView sharedAlertView] showQuizView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
