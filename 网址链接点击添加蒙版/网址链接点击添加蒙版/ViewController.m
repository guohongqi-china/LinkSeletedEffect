//
//  ViewController.m
//  网址链接点击添加蒙版
//
//  Created by MacBook on 16/12/20.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "ViewController.h"
#import "URLSeletedLabel.h"
#import "网址链接点击添加蒙版-Swift.h"
#import "TextAttributeString.h"
#import "ResultAttributeModel.h"
#import "JSONModel.h"
#import "CommonString.h"

@interface ViewController ()<URLSeletedLabelDelegate>
@property (strong, nonatomic) IBOutlet URLSeletedLabel *urlLabel;
/** 属性 */
@property (nonatomic, strong) HYLabel *attributeLabel;
/** <#注释#> */
@property (strong, nonatomic) IBOutlet HYLabel *bottomLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (nonatomic, strong) URLSeletedLabel *topLabel;
@property (strong, nonatomic) IBOutlet UIButton *sender1;
/** view */
@property (nonatomic, strong) UIView *redView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    ResultAttributeModel *model = [TextAttributeString attributedStringSubset:@"http://foo.com/blah_blah 法师[悲哀]打发斯蒂芬 急急急#着他吧#发的说法[挖鼻屎]发浓缩的烦恼 http://baidu.com" textFont:30];
    _urlLabel.specialColor = [UIColor blueColor];
    _urlLabel.seletedColor = [UIColor grayColor];
    
    _urlLabel.textFont  = 30;
    _urlLabel.attributedText = [model.resultAttStr copy];
    
}
- (IBAction)sender:(UIButton *)sender {
    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        _redView.frame = CGRectMake(150, 50, 100, 100);
    } completion:^(BOOL finished) {

    }];

}

#pragma mark - =============URLSeletedLabelDelegate==================

- (void)didSeletedTextType:(seletedTextType)seletedType seletedContent:(NSString *)content
{

    if (seletedType == seletedTextLink) {
        [[UIApplication sharedApplication]openURL:[ NSURL URLWithString:content] options:@{} completionHandler:^(BOOL success) {
            NSLog(@"=======成功了");
        }];

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
