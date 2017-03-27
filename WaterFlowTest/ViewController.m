//
//  ViewController.m
//  WaterFlowTest
//
//  Created by liquangang on 2016/11/12.
//  Copyright © 2016年 liquangang. All rights reserved.
//

#import "ViewController.h"
#import "WaterLayout.h"

@interface ViewController ()<UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout,
                             UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *testCollectionView;
@property (nonatomic, strong) NSMutableArray *testMuArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    for (int i = 0; i < 10000; i++) {
        UIColor *cellColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        NSNumber *height;
        switch (i % 4) {
            case 0:
            {
                height = @(50);
            }
                break;
            case 1:
            {
                height = @(350);
            }
                break;
            case 2:
            {
                height = @(350);
            }
                break;
            case 3:
            {
                height = @(50);
            }
                break;
                
            default:
                break;
        }
        [self.testMuArray addObject:@{@"color":cellColor, @"cellHeight":height}];
    }
    [self.testCollectionView reloadData];
}

#pragma mark - collectionview 代理

- (NSInteger)collectionView:(UICollectionView *)collectionView
             numberOfItemsInSection:(NSInteger)section{
    return self.testMuArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    cell.backgroundColor = self.testMuArray[indexPath.row][@"color"];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static BOOL isScroll = NO;
    if (!isScroll) {
        isScroll = YES;
    }
}

#pragma mark - 懒加载
- (UICollectionView *)testCollectionView{
    if (!_testCollectionView) {
        __weak typeof(self) weakSelf = self;
        WaterLayout *waterLayout = [WaterLayout new];
        waterLayout.columnCount = 2;
        [waterLayout setGetItemHeightBlock:^CGFloat(NSIndexPath *indexPath) {
            return [weakSelf.testMuArray[indexPath.row][@"cellHeight"] floatValue];
        }];
        _testCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                 collectionViewLayout:waterLayout];
        [self.view addSubview:_testCollectionView];
        _testCollectionView.delegate = self;
        _testCollectionView.dataSource = self;
        [_testCollectionView registerClass:[UICollectionViewCell class]
                forCellWithReuseIdentifier:@"cell"];
    }
    return _testCollectionView;
}

- (NSMutableArray *)testMuArray{
    if (!_testMuArray) {
        _testMuArray = [NSMutableArray new];
    }
    return _testMuArray;
}
@end
