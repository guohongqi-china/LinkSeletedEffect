//
//  EmotionCollectionViewCell.h
//  图文混排
//
//  Created by MacBook on 16/12/14.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionModel.h"

@interface EmotionCollectionViewCell : UICollectionViewCell
/** 表情 */
//@property (nonatomic, strong) UIButton *emtionButton;
@property (strong, nonatomic) IBOutlet UIButton *emtionButton;

/** 表情模型 */
@property (nonatomic, strong) EmotionModel *emtion;
/** 表视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
