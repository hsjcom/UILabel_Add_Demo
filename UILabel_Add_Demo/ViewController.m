//
//  ViewController.m
//  UILabel_Add_Demo
//
//  Created by Soldier on 2016/11/23.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+Add.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *oriTextBtn;

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(250, 250, 250, 1);
    
    [self constructSegmentControl];
    [self textLabel];
    [self constructOriTextBtn];
}

- (void)constructSegmentControl {
    NSArray *segmentArray = @[@"TEXT", @"HTML"];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    segmentControl.frame = CGRectMake(self.view.frame.size.width * 0.5 - 60, 25, 140, 35);
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = [UIColor orangeColor];
    [segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentControl];
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(16, 80, self.view.frame.size.width - 32, self.view.frame.size.height - 64)];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.userInteractionEnabled = YES;

        [self.view addSubview:_label];
    }
    return _label;
}

- (void)constructOriTextBtn {
    _oriTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _oriTextBtn.frame = CGRectMake(self.view.frame.size.width - 50, 45, 30, 20);
    [_oriTextBtn setTitle:@"原文" forState:UIControlStateNormal];
    _oriTextBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_oriTextBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_oriTextBtn addTarget:self action:@selector(oriTextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_oriTextBtn];
    _oriTextBtn.hidden = YES;
}

- (void)textLabel{
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.lineSpace = 10;
    self.label.wordSpace = 10;
    self.label.keywords = @"困难于其易，为大于其细。天下难事必作于易，天下大事必于细。";
    self.label.keywordsFont = [UIFont boldSystemFontOfSize:20];
    self.label.keywordsColor = [UIColor orangeColor];
    self.label.underlineStr = @"夫轻诺必寡信，多易必多难。";
    self.label.underlineColor = [UIColor orangeColor];
    
    self.label.styleText = @"为无为，事无事，味无味。大小多少，报怨以德。困难于其易，为大于其细。天下难事必作于易，天下大事必于细。是以圣人终不为大，故能成其大。夫轻诺必寡信，多易必多难。是以圣人犹难之，故终无难矣。";
    
    [self.label sizeToFit];
    self.label.frame = CGRectMake(20, 80, self.view.frame.size.width - 40, self.label.frame.size.height);
}

- (void)htmlLabel{
    self.label.htmlString = [self htmlStr];
    //改变字体需在设置htmlString之后设置
    self.label.font = [UIFont systemFontOfSize:18];
    [self.label sizeToFit];
    self.label.frame = CGRectMake(20, 80, self.view.frame.size.width - 40, self.label.frame.size.height);
}

- (void)oriTextAction {
    self.label.text = [self htmlStr];
    self.label.font = [UIFont systemFontOfSize:18];
    [self.label sizeToFit];
    self.label.frame = CGRectMake(20, 80, self.view.frame.size.width - 40, self.label.frame.size.height);
}

- (NSString *)htmlStr {
    return @"<html><font color=\"#6c6c6c\">为无为，事无事，味无味。大小多少，报怨以德。<font color=\"#ff9147\">困难于其易，为大于其细。天下难事必作于易，天下大事必于细。<a href=\"https://www.baidu.com\">是以圣人终不为大，故能成其大</a>夫轻诺必寡信，多易必多难。是以圣人犹难之，故终无难矣。</html>";
}

- (void)didClickSegmentedControlAction:(UISegmentedControl *)segmentControl {
    NSInteger idx = segmentControl.selectedSegmentIndex;
    
    if (idx == 0) {
        [self textLabel];
        _oriTextBtn.hidden = YES;
    } else if (idx == 1) {
        [self htmlLabel];
        _oriTextBtn.hidden = NO;
    }
}


@end
