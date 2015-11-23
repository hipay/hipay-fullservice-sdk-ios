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
    
    self.itemSize = CGSizeMake(80., 60.);
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

const NSInteger kVerticalSpacing = 10;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* currentItemAttributes =
    [super layoutAttributesForItemAtIndexPath:indexPath];
    UIEdgeInsets sectionInset = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout sectionInset];
    if (indexPath.item == 0) {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.y = sectionInset.top;
        currentItemAttributes.frame = frame;
        
        return currentItemAttributes;
    }
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.y + previousFrame.size.height + kVerticalSpacing;
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(currentFrame.origin.x,
                                              0,
                                              currentFrame.size.width,
                                              self.collectionView.frame.size.height
                                              );
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame)) {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.y = frame.origin.y = sectionInset.top;
        currentItemAttributes.frame = frame;
        return currentItemAttributes;
    }
    CGRect frame = currentItemAttributes.frame;
    frame.origin.y = previousFrameRightPoint;
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}


@end