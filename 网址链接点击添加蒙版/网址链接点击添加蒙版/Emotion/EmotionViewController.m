//
//  EmotionViewController.m
//  图文混排
//
//  Created by MacBook on 16/12/9.
//  Copyright © 2016年 MacBook. All rights reserved.
//
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "EmotionViewController.h"
#import "UIView+XMGExtension.h"
#import "EmotionManager.h"
#import "EmotionCollectionViewCell.h"

@interface EmotionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UITextView *inputView;
}
/** 集合视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 工具条 */
@property (nonatomic, strong) UIToolbar *toolBar;
/** 表情数据 */
@property (nonatomic, strong) EmotionManager *emotionManager;
@end

@implementation EmotionViewController

/** cell标识符 */
static NSString *identifier = @"cell";
#pragma mark - =============懒加载==================
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        /** 流水布局 */
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置每个item的大小，
        CGFloat itemWH = kScreenWidth / 7;
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        // 设置列的最小间距
        flowLayout.minimumInteritemSpacing = 0;
        // 设置最小行间距
        flowLayout.minimumLineSpacing = 0;

        // 滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        /** 设置内容 */
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.x = 0;
        _collectionView.y = 0;
        _collectionView.width = self.view.width;
        _collectionView.height = 218 - 45;
        _collectionView.backgroundColor = [UIColor purpleColor];
        CGFloat topSpace = (_collectionView.height - itemWH * 3) / 2;
        _collectionView.contentInset = UIEdgeInsetsMake(topSpace, 0, topSpace, 0);
    }
    return _collectionView;
}
- (UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc]init];
        _toolBar.backgroundColor = [UIColor grayColor];
        _toolBar.x = 0;
        _toolBar.y = 218 - 45;
        _toolBar.width = self.view.width;
        _toolBar.height = 45;
        
        /** 设置toolbar属性 */
        NSArray *itemsNmaeArr = @[@"最近",@"默认",@"emoji",@"浪小花",@"发送"];
        NSInteger index  = 0;
        NSMutableArray *itemArr = [NSMutableArray array];
        for (NSString *itemName in itemsNmaeArr) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:itemName style:(UIBarButtonItemStylePlain) target:self action:@selector(itemAction:)];
            item.tag = 1000 + index;
            index ++;
            [itemArr addObject:item];
            [itemArr addObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil]];
        }
        [itemArr removeLastObject];
        _toolBar.items = itemArr;
        _toolBar.tintColor = [UIColor orangeColor];
        
    }
    return  _toolBar;
}
- (void)itemAction:(UIBarButtonItem *)item{
    NSInteger tag = item.tag - 1000;
    if (tag == 4) {
        if (self.Delegate && [self.Delegate respondsToSelector:@selector(sendText)]) {
            [self.Delegate sendText];
        }
        return;
    }
    EmotionPackAge *emotionS = _emotionManager.emotionS[tag];
    
    if (!emotionS.emotionArr.count) {
        return;
    }    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:item.tag - 1000] atScrollPosition:(UICollectionViewScrollPositionLeft) animated:YES];
    
}
- (instancetype)initWithTextField:(UITextView *)textView
{
    if (self = [super init]) {
        inputView = textView;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1、布局
    [self setUpUI];
    
    // 2、设置数据
    [self setUpData];
}
- (void)setUpData{
    /** 加载表情数据 */
    EmotionManager *manager = [[EmotionManager alloc]init];
    _emotionManager = manager;
    
}
- (void)setUpUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    /** 添加子视图 */
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolBar];
    
    /** 设置数据源代理 */
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EmotionCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

}

#pragma mark - =============UICollectionViewDataSource==================

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    EmotionPackAge *emotionS = _emotionManager.emotionS[section];

    return emotionS.emotionArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _emotionManager.emotionS.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //1、创建cell
    EmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //2、设置数据
    EmotionPackAge *emotionS = _emotionManager.emotionS[indexPath.section];
    EmotionModel *emotionModel = emotionS.emotionArr[indexPath.row];
    cell.emtion = emotionModel;
    cell.collectionView = collectionView;
    cell.indexPath = indexPath;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EmotionPackAge *emotionS = _emotionManager.emotionS[indexPath.section];
    EmotionModel *emotionModel = emotionS.emotionArr[indexPath.row];
    
    /** 设置代理 */
    if (self.Delegate && [self.Delegate respondsToSelector:@selector(didSeletedButtonIndex:)]) {
        [self.Delegate didSeletedButtonIndex:emotionModel];
    }
    [self inputViewContentSetting:emotionModel];
    /** 当为空或者删除表情时返回 */
    if (emotionModel.isNull || emotionModel.isRemove) {
        return;
    }
    [self insertRecelentEmotion:emotionModel indexPath:indexPath];
    
   

}

- (void)insertRecelentEmotion:(EmotionModel *)emotion indexPath:(NSIndexPath *)indexPath{
    EmotionPackAge *emotionS = _emotionManager.emotionS.firstObject;

    [emotionS.emotionArr insertObject:emotion atIndex:0];
    [emotionS.emotionArr removeObjectAtIndex:emotionS.emotionArr.count - 2];
}

/** 设置输入框显示内容 */
- (void)inputViewContentSetting:(EmotionModel *)emotion{
    /** 1、当是空白表情时不做任何操作 */
    if (emotion.isNull) {
        return;
    }
    /** 2、当是删除按钮时 */
    if (emotion.isRemove) {
        //删除光标之前的一个字；注意：是光标之前的一个字，不是最后一个字
        [inputView deleteBackward];
        return;
    }
    /** 3、插入emoji表情字符 */
    if (emotion.emojiCode) {
        //1、获取到光标所在位置
        UITextRange *range = inputView.selectedTextRange;
        //2、插入emoji表情
        [inputView replaceRange:range withText:emotion.emojiCode];
        return;
    }
    
    /** 4、插入图片 */
    //（1）、根据图片路径创建字符串
    NSTextAttachment *imageAchment = [[NSTextAttachment alloc]init];
    imageAchment.image = [UIImage imageWithContentsOfFile:emotion.pathImage];
    UIFont *font = inputView.font;
    imageAchment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight);
    //生成属性字符
    NSAttributedString *attrMStr = [NSAttributedString attributedStringWithAttachment:imageAchment];
    
    //（2）、创建属性字符串
    NSMutableAttributedString *textAttributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:inputView.attributedText];
    NSRange range1 = inputView.selectedRange;
    //替换字符
    [textAttributeStr replaceCharactersInRange:range1 withAttributedString:attrMStr];
    
    //（3）、显示属性文字
    inputView.attributedText = textAttributeStr;
    NSLog(@"%ld",textAttributeStr.length);
    
    inputView.font = font;
    //将光标重置
    inputView.selectedRange = NSMakeRange(range1.location + 1, 0);
}



















@end
