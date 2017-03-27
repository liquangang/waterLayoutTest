//
//  WaterLayout.h
//  WaterFlowTest
//
//  Created by liquangang on 2016/11/12.
//  Copyright © 2016年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterLayout : UICollectionViewLayout


/**
 *  行间距（默认值为0）
 */
@property (nonatomic, assign) CGFloat rowMargin;

/**
 *  列间距（默认值为0）
 */
@property (nonatomic, assign) CGFloat columnMargin;

/**
 *  组间距（默认都为0）
 */
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

/**
 *  列数（默认一列）
 */
@property (nonatomic, assign) NSInteger columnCount;

/**
 *  获取item高度的block
 */
@property (nonatomic, copy) CGFloat(^getItemHeightBlock)(NSIndexPath *indexPath);
@end
