//
//  ViewController.m
//  瀑布流
//
//  Created by Wicrenet_Jason on 2017/6/22.
//  Copyright © 2017年 Wicrenet_Jason. All rights reserved.
//

#import "ViewController.h"
#import "MKJParseHelper.h"
#import <CHTCollectionViewWaterfallLayout.h>
#import "FirstCollectionViewCell.h"
#import "RedBookModel.h"
#import <UIImageView+WebCache.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *lists;
@property (strong, nonatomic) CHTCollectionViewWaterfallLayout *customLayout;

@end

static NSString *identify1 = @"FirstCollectionViewCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.customLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    self.customLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // sectionHeader高度
    //    self.customLayout.headerHeight = 80;
    // sectionFooterHeight
    //    self.CHTLayout.footerHeight = 10;
    // 间距
    self.customLayout.minimumColumnSpacing = 10;
    self.customLayout.minimumInteritemSpacing = 10;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:self.customLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:identify1 bundle:nil] forCellWithReuseIdentifier:identify1];

    [self refreshData];
}

- (void)refreshData
{
    __weak typeof(self)weakSelf = self;
    [[MKJParseHelper shareHelper] requestData:^(id obj, NSError *error) {
        
        weakSelf.lists = (NSArray *)obj;
        [weakSelf.collectionView reloadData];
        
        
    } failure:^(id obj, NSError *error) {
        
    }];
}

- (NSArray *)lists
{
    if (_lists == nil) {
        _lists = [[NSArray alloc] init];
    }
    return _lists;
}



#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify1 forIndexPath:indexPath];
    [self configCell:cell indexpath:indexPath];
    return cell;
}


- (void)configCell:(FirstCollectionViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    RedBookDetails *bookDetail = self.lists[indexpath.item];
    __weak typeof(cell)weakCell = cell;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bookDetail.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && cacheType == SDImageCacheTypeNone) {
            weakCell.imageView.alpha = 0;
            [UIView animateWithDuration:2.0 animations:^{
                
                weakCell.imageView.alpha = 1.0f;
                
            }];
        }
        else
        {
            weakCell.imageView.alpha = 1.0f;
        }
    }];
    
    [cell.imageView layoutIfNeeded];
    if ([bookDetail.h floatValue] > [bookDetail.w floatValue]) {
        CGFloat rate = [bookDetail.h floatValue] / [bookDetail.w floatValue];
        cell.imageViewHeight.constant = (kScreenWidth - 30) / 2 * rate;
    }
    else
    {
        cell.imageViewHeight.constant = (kScreenWidth - 30) / 2;
    }
    
    cell.descLabel.text = bookDetail.des;
    cell.nameLabel.text = bookDetail.name;
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:bookDetail.icon]];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RedBookDetails *bookDetail = self.lists[indexPath.item];
    if ([bookDetail.h floatValue] > [bookDetail.w floatValue]) {
        CGFloat rate = [bookDetail.h floatValue] / [bookDetail.w floatValue];
        rate = ((kScreenWidth - 30) / 2 * rate + 120 )  / ((kScreenWidth - 30) / 2);
        return CGSizeMake(1,rate);
        
    }
    else
    {
        CGFloat rate = ((kScreenWidth - 30) / 2 + 120 )  / ((kScreenWidth - 30) / 2);
        return CGSizeMake(1, rate);
    }
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    RedBookDetails *bookDetail = self.lists[indexPath.item];
//    CGFloat rate = [bookDetail.h floatValue] / [bookDetail.w floatValue];
//    CGRect descRec = CGRectMake(0, 64 + 50, kScreenWidth, kScreenWidth * rate);
//    CGRect originalRec;
//    UIImageView *imageView = nil;
//    FirstCollectionViewCell *firstCell = (FirstCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    
//    originalRec = [firstCell.imageView convertRect:firstCell.imageView.frame toView:self.view];
//    imageView = firstCell.imageView;
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
