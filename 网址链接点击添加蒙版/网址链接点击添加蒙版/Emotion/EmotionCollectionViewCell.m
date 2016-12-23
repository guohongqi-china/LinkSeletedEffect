//
//  EmotionCollectionViewCell.m
//  图文混排
//
//  Created by MacBook on 16/12/14.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "EmotionCollectionViewCell.h"
#import "UIView+XMGExtension.h"

@implementation EmotionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    

}

- (void)setEmtion:(EmotionModel *)emtion{
    _emtion = emtion;
    [self.emtionButton setImage:[UIImage imageWithContentsOfFile:emtion.pathImage] forState:(UIControlStateNormal)];
    [self.emtionButton setTitle:emtion.emojiCode forState:(UIControlStateNormal)];
    [self.emtionButton addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    if (emtion.isRemove) {
        [self.emtionButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:(UIControlStateNormal)];

    }
}


- (void)buttonAction{
    if(self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]){
        [self.collectionView.delegate collectionView:_collectionView didSelectItemAtIndexPath:_indexPath];
    };
}




@end
