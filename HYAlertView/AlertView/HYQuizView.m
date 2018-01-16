//
//  HYQuizView.m
//  HYDasset
//
//  Created by 降瑞雪 on 2018/1/15.
//  Copyright © 2018年 汇元网. All rights reserved.
//

#import "HYQuizView.h"
#import "SDAutoLayout.h"

@interface HYQuizView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImage *qrImage;
@property (nonatomic,copy) NSDictionary *question;
@property (nonatomic,copy) NSArray * questioneArr;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,weak) UILabel * content;
@property (nonatomic,weak) UILabel * indexLabel;
@property (nonatomic,weak) UIButton * option01;
@property (nonatomic,weak) UIButton * option02;

@end

@implementation HYQuizView


+ (instancetype)sharedAlertView {
    static HYQuizView *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HYQuizView alloc] init];
        _instance.questioneArr = @[
                                   @{
                                       @"content":@"新建的Dasset账户，首选要做的是什么？",
                                       @"answer": @"A 备份",
                                       @"options":@[@"A 备份",@"B 管理"]
                                       },
                                   @{
                                       @"content":@"未备份的账户资产丢失时，是否能找回",
                                       @"answer": @"B 不能",
                                       @"options":@[@"A 能",@"B 不能"]
                                       },
                                   @{
                                       @"content":@"用户忘记账户密码时，该账户资产是否还能找回?",
                                       @"answer": @"A 不能",
                                       @"options":@[@"A 不能",@"B 能"]
                                       }
                                   ];
    });
    return _instance;
}

- (void)showQuizView
{
    if (self.questioneArr.count == 0) {
        return;
    }
    
    _index = 0;
    self.question = _questioneArr.firstObject;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.maskView = [[UIView alloc] initWithFrame:window.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window addSubview:self.maskView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 3.f;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    contentView.layer.shadowOffset = CGSizeMake(0, -1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    contentView.layer.shadowOpacity = 0.5;//0.8;//阴影透明度，默认0
    [window addSubview:contentView];
    self.containerView = contentView;
    contentView.sd_layout
    .widthIs(300)
    .heightIs(360)
    .centerXEqualToView(window)
    .centerYEqualToView(window);
    
    UILabel *titleLabel = ({
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.text = @"区块链知识小测试";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel;
    });
    [contentView addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 30)
    .heightIs(40);
    
    
    //二维码展示
    UILabel *detailLabel = ({
        UILabel *detailLabel = [UILabel new];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.text = @"为了保障您在系统内的账户安全，须具有一定的区块链知识。请您配合完成以下测试才能启用应用。";
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.numberOfLines = 0;
        detailLabel;
    });
    [contentView addSubview:detailLabel];
    detailLabel.sd_layout
    .leftSpaceToView(contentView, 25)
    .rightSpaceToView(contentView, 25)
    .topSpaceToView(titleLabel, 25)
//    .heightIs(120);
    .autoHeightRatio(0);
    
    
    //分割线显示
    UILabel *separatorLb = ({
        UILabel *_separatorLb = [UILabel new];
        _separatorLb.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _separatorLb;
    });
    [contentView addSubview:separatorLb];
    separatorLb.sd_layout
    .topSpaceToView(detailLabel, 15)
    .leftSpaceToView(contentView, 25)
    .rightSpaceToView(contentView, 15)
    .heightIs(1);
    
    //题索引
    UILabel *indexLabel = ({
        UILabel *indexLabel = [UILabel new];
        indexLabel.font = [UIFont boldSystemFontOfSize:17];
//        indexLabel.textColor = [HYUtilis colorWithHexString:@"#5757FF"];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.text = @"1/3";
        indexLabel;
    });
    [contentView addSubview:indexLabel];
    self.indexLabel = indexLabel;
    indexLabel.sd_layout
    .topSpaceToView(separatorLb, 15)
    .leftSpaceToView(contentView, 25)
    .rightSpaceToView(contentView, 25)
    .heightIs(24);
    
    
    //题的内容
    UILabel *contentLabel = ({
        UILabel *contentLabel = [UILabel new];
        contentLabel.font = [UIFont systemFontOfSize:17];
        contentLabel.text = self.question[@"content"];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 0;
        contentLabel;
    });
    [contentView addSubview:contentLabel];
    self.content = contentLabel;
    contentLabel.sd_layout
    .leftSpaceToView(contentView, 25)
    .rightSpaceToView(contentView, 25)
    .topSpaceToView(indexLabel, 40)
    .autoHeightRatio(0);
    
    
    NSArray * optionArr = self.question[@"options"];
    //答案01
    UIButton *optionsButton01 = ({
        UIButton *optionsButton01 = [UIButton buttonWithType:UIButtonTypeCustom];
         optionsButton01.tag = 101;
        optionsButton01.layer.cornerRadius = 4.0f;
        optionsButton01.layer.masksToBounds = YES;
        optionsButton01.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [optionsButton01 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        optionsButton01.layer.borderColor = [UIColor darkGrayColor].CGColor;
        optionsButton01.layer.borderWidth = 0.8f;
        [optionsButton01 setTitle:optionArr.firstObject forState:UIControlStateNormal];
        [optionsButton01 addTarget:self action:@selector(optionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        optionsButton01;
    });
    [contentView addSubview:optionsButton01];
     self.option01 = optionsButton01;
    optionsButton01.sd_layout
    .leftSpaceToView(contentView, 25)
    .topSpaceToView(contentLabel, 25)
    .widthIs(120)
    .heightIs(44);
    
    //答案02
    UIButton *optionsButton02 = ({
        UIButton *optionsButton02 = [UIButton buttonWithType:UIButtonTypeCustom];
        optionsButton02.tag = 100;
        optionsButton02.layer.cornerRadius = 4.0f;
        optionsButton02.layer.borderWidth = 0.8f;
        optionsButton02.layer.masksToBounds = YES;
        optionsButton02.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [optionsButton02 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        optionsButton02.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [optionsButton02 setTitle:optionArr.lastObject forState:UIControlStateNormal];
        [optionsButton02 addTarget:self action:@selector(optionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        optionsButton02;
    });
    [contentView addSubview:optionsButton02];
    self.option02 = optionsButton02;
    optionsButton02.sd_layout
    .rightSpaceToView(contentView, 25)
    .topSpaceToView(contentLabel, 25)
    .widthIs(120)
    .heightIs(44);
    
    [contentView setupAutoHeightWithBottomView:optionsButton02 bottomMargin:25];
}

- (void)dimiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(0, 0);
        self.alpha = 0;
        self.maskView.alpha = 0;
        self.containerView.alpha = 0;
    }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self.maskView removeFromSuperview];
                         [self.containerView removeFromSuperview];
                     }];
}
#pragma mark - Button Action
-(void)optionsButtonTapped:(UIButton *)sender{
   
    NSDictionary * theQuestion = self.questioneArr[_index];
    NSString *answer = theQuestion[@"answer"];
    if ([answer isEqualToString:sender.titleLabel.text]) {
        //答题正确
//        hy_showToastDelay(@"答题正确", 1);
        NSLog(@"答题正确");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (_index + 1 == self.questioneArr.count) {
//                hy_showToast(@"恭喜您完成区块链基础培训");
                NSLog(@"恭喜您完成区块链基础培训");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dimiss];
                });
                return;
            }
            [self updataQuiz];
        });
    }
    else {
        //答题错误
//         hy_showToastDelay(@"答题错误", 1);
        NSLog(@"答题错误");
    }
}

- (void)updataQuiz
{
    NSDictionary * theQuestion = self.questioneArr[++_index];
    NSArray *optionArr = theQuestion[@"options"];
    self.content.text = theQuestion[@"content"];
    [self.option01 setTitle:optionArr.firstObject forState:UIControlStateNormal];
    [self.option02 setTitle:optionArr.lastObject forState:UIControlStateNormal];
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(_index + 1),@(self.questioneArr.count)];
}

@end

