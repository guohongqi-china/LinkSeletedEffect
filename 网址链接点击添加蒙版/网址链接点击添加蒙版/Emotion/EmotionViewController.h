//
//  EmotionViewController.h
//  图文混排
//
//  Created by MacBook on 16/12/9.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionModel.h"

@protocol EmotionViewControllerDelegate<NSObject>
- (void)didSeletedButtonIndex:(EmotionModel *)emotion;
- (void)sendText;
@end

@interface EmotionViewController : UIViewController
/** 代理 */
@property (nonatomic, assign) id<EmotionViewControllerDelegate> Delegate;

- (instancetype)initWithTextField:(UITextView *)textView;


@end
