//
//  MASatisfactionView.m
//  RyWebChat
//
//  Created by nwk on 2017/2/20.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MASatisfactionView.h"

@interface MASatisfactionView()
{
    UIButton *radio1Btn;
    UIButton *radio2Btn;
    UITextField *textField;
}

@end

@implementation MASatisfactionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

+ (instancetype)newSatisfactionView {
    MASatisfactionView *satisfactionView = [[MASatisfactionView alloc] init];
    CGRect winRect = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(winRect), CGRectGetHeight(winRect));
    satisfactionView.frame = frame;
    satisfactionView.backgroundColor = [UIColor clearColor];
    [satisfactionView setupUI];
    
    return satisfactionView;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [self addSubview:bgView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.frame)-20, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.center = bgView.center;
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(contentView.frame), 30)];
    title.text = @"满意度评价";
    title.font = [UIFont systemFontOfSize:20];
    [contentView addSubview:title];
    
    radio1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    radio1Btn.frame = CGRectMake(50, CGRectGetMaxY(title.frame)+10, 100, 40);
    [radio1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [radio1Btn setTitle:@"满意" forState:UIControlStateNormal];
    [radio1Btn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    [radio1Btn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];
    [radio1Btn addTarget:self action:@selector(clickRadioButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:radio1Btn];
    
    radio2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    radio2Btn.frame = CGRectMake(CGRectGetMaxX(radio1Btn.frame)+50, CGRectGetMaxY(title.frame)+10, 100, 40);
    [radio2Btn setTitle:@"不满意" forState:UIControlStateNormal];
    [radio2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [radio2Btn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    [radio2Btn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];
    [radio2Btn addTarget:self action:@selector(clickRadioButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:radio2Btn];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(radio2Btn.frame)+10, CGRectGetWidth(self.frame)-20, 40)];
    
    [contentView addSubview:textField];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetWidth(contentView.frame)-120, CGRectGetMaxY(textField.frame)+10, 100, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contentView addSubview:sureBtn];
    
    
    [self clickRadioButton:radio1Btn];
}

- (void)clickRadioButton:(UIButton *)button {
    radio1Btn.selected = NO;
    radio2Btn.selected = NO;
    
    radio1Btn == button ? (radio1Btn.selected=!radio1Btn.selected) : (radio2Btn.selected = !radio2Btn.selected);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeFromSuperview];
}

@end
