//
//  HPTPaymentProductsFlowLayout.m
//  Pods
//
//  Created by Jonathan TIRET on 27/10/2015.
//
//

#import "HPTPaymentProductsFlowLayout.h"

@implementation HPTPaymentProductsFlowLayout

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.itemSize = CGSizeMake(90., 60.);
    self.minimumInteritemSpacing = 10.;
    self.minimumLineSpacing = 10.;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0., 10., 0., 10.);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if ((proposedContentOffset.x + self.collectionView.frame.size.width) > (self.collectionViewContentSize.width - self.itemSize.width / 2.0)) {
        return CGPointMake(self.collectionViewContentSize.width - self.collectionView.frame.size.width, proposedContentOffset.y);
    }
    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalOffset = proposedContentOffset.x + 5;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        CGFloat itemOffset = layoutAttributes.frame.origin.x;
        if (ABS(itemOffset - horizontalOffset) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemOffset - horizontalOffset;
        }
    }
    
    offsetAdjustment -= self.sectionInset.left / 2.0;
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end