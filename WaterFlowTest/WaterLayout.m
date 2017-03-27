//
//  WaterLayout.m
//  WaterFlowTest
//
//  Created by liquangang on 2016/11/12.
//  Copyright © 2016年 liquangang. All rights reserved.
//

#import "WaterLayout.h"

@interface WaterLayout()
//每一列的最大y值
@property (nonatomic, strong) NSMutableArray *columnMaxYArray;
//所有cell的布局属性数组
@property (nonatomic, strong) NSMutableArray *attrsMuArray;
//最大的y值，用来设置collectionview的size
@property (nonatomic, assign) CGFloat maxY;
//总空白区域宽度
@property (nonatomic, assign) CGFloat columnAllMargin;
//cell的宽度
@property (nonatomic, assign) CGFloat cellWidth;
@end

@implementation WaterLayout

/**
 * collectionView的contentSize
 */
- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.maxY + self.sectionInsets.bottom);
}

- (void)prepareLayout{
    
    // 计算所有cell的布局属性
    [self.attrsMuArray removeAllObjects];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsMuArray addObject:attrs];
    }
}

/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsMuArray;
}

/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
    
    // 水平方向上的总间距
//    CGFloat xMargin = self.sectionInsets.left + self.sectionInsets.right + (self.columnCount - 1) * self.columnMargin;
//    CGFloat xMargin = self.columnAllMargin;
//    // cell的宽度
//    CGFloat w = (CGRectGetWidth(self.collectionView.frame) - xMargin) / self.columnCount;
    // cell的高度，测试数据，随机数
    CGFloat h = self.getItemHeightBlock(indexPath);
    
    // 找出最短那一列的 列号 和 这一列的最大Y值
    CGFloat destMaxY = [self.columnMaxYArray[0] doubleValue];
    NSUInteger destColumn = 0;
    CGFloat maxY = destMaxY;
    for (NSUInteger i = 1; i<self.columnMaxYArray.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYArray[i] doubleValue];
        
        // 找出数组中的最小值
        if (destMaxY > columnMaxY) {
            destMaxY = columnMaxY;
            destColumn = i;
        }
        
        //找出最大的y值
        if (maxY < columnMaxY) {
            maxY = columnMaxY;
        }
    }
    
    // cell的x值
    CGFloat x = self.sectionInsets.left + destColumn * (self.cellWidth + self.columnMargin);
    // cell的y值
    CGFloat y = destMaxY + self.rowMargin;
    // cell的frame
    attrs.frame = CGRectMake(x, y, self.cellWidth, h);
    
    // 更新数组中的刚才最短一列的最大Y值
    self.columnMaxYArray[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    //更新最大y值
    self.maxY = CGRectGetMaxY(attrs.frame) > maxY ? CGRectGetMaxY(attrs.frame) : maxY;
    return attrs;
}

#pragma mark - 懒加载

- (NSInteger)columnCount{
    if (_columnCount == 0) {
        _columnCount = 1;
    }
    return _columnCount;
}

- (NSMutableArray *)columnMaxYArray{
    if (!_columnMaxYArray) {
        _columnMaxYArray = [NSMutableArray new];
        
        for (NSUInteger i = 0; i < self.columnCount; i++) {
            [_columnMaxYArray addObject:@(self.sectionInsets.top)];
        }
    }
    return _columnMaxYArray;
}

- (NSMutableArray *)attrsMuArray{
    if (!_attrsMuArray) {
        _attrsMuArray = [NSMutableArray new];
    }
    return _attrsMuArray;
}

- (CGFloat)columnAllMargin{
    static BOOL isAlreadyCalculationColumnAllMargin = NO;
    if (!isAlreadyCalculationColumnAllMargin) {
        if (self.sectionInsets.left == 0 && self.sectionInsets.right == 0 && self.columnMargin == 0) {
            _columnAllMargin = 0;
        }else{
            _columnAllMargin = self.sectionInsets.left + self.sectionInsets.right + (self.columnCount - 1) * self.columnMargin;
        }
        isAlreadyCalculationColumnAllMargin = YES;
    }
    return _columnAllMargin;
}

- (CGFloat)cellWidth{
    if (_cellWidth == 0) {
        _cellWidth = (CGRectGetWidth(self.collectionView.frame) - self.columnAllMargin) / self.columnCount;
    }
    return _cellWidth;
}
@end
