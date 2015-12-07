//
//  HPFPaymentProductsFlowLayout.m
//  Pods
//
//  Created by Jonathan TIRET on 27/10/2015.
//
//

#import "HPFPaymentProductsFlowLayout.h"

@implementation HPFPaymentProductsFlowLayout

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.minimumInteritemSpacing = 10.;
    self.minimumLineSpacing = 10.;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void)setCollectionViewSize:(CGSize)collectionViewSize
{
    _collectionViewSize = collectionViewSize;
    
    CGFloat minWidth = fmin(collectionViewSize.width / 4.0, 100.0);
    
    CGFloat currentNumberOfVisibleItems = collectionViewSize.width / (minWidth + self.minimumInteritemSpacing);
    
    CGFloat preferredNumberOfVisibleItems = currentNumberOfVisibleItems - fmod(currentNumberOfVisibleItems, 0.5);
    
    if (fmod(preferredNumberOfVisibleItems, 1.0) == 0.0) {
        preferredNumberOfVisibleItems -= 0.5;
    }
    
    CGFloat preferredItemWidth = collectionViewSize.width / preferredNumberOfVisibleItems - self.minimumInteritemSpacing;
    
    self.itemSize = CGSizeMake(preferredItemWidth, 60.0);
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