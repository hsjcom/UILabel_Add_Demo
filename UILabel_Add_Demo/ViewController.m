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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(250, 250, 250, 1);
    
    [self constructView];
}

- (void)constructView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 64, self.view.frame.size.width - 32, 350)];
    label.font = [UIFont systemFontOfSize:18];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    label.lineSpace = 10;
    label.wordSpace = 10;
    label.keywords = @"困难于其易，为大于其细。天下难事必作于易，天下大事必于细。";
    label.keywordsFont = [UIFont boldSystemFontOfSize:20];
    label.keywordsColor = [UIColor orangeColor];
    label.underlineStr = @"夫轻诺必寡信，多易必多难。";
    label.underlineColor = [UIColor orangeColor];
    
    label.styleText = @"为无为，事无事，味无味。大小多少，报怨以德。困难于其易，为大于其细。天下难事必作于易，天下大事必于细。是以圣人终不为大，故能成其大。夫轻诺必寡信，多易必多难。是以圣人犹难之，故终无难矣。";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
