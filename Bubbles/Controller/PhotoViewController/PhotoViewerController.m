//
//  PhotoViewerController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 04.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "PhotoViewerController.h"
#import "UIColor+NFSColors.h"
#import "ASViewController+CloseButton.h"
#import "PersistencyManager.h"
#import "NavigationController.h"
#import "PhotoViewerCellNode.h"

@interface PhotoViewerController ()<ASCollectionDelegateFlowLayout, ASCollectionDataSource, UIGestureRecognizerDelegate>
@property (strong, nonatomic) ASCollectionNode *collectionNode;
@property (nonatomic) BOOL isBarHidden;
@property (nonatomic) NSUInteger indexToShow;
@end

@implementation PhotoViewerController {
    CGPoint viewTranslation;
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    [[self collectionNode] reloadData];
    [self animateCollectionView];
}

- (void)animateCollectionView {
    CGFloat currentOffset = [[self collectionNode] contentOffset].x;
    CGFloat yOffset = [[self collectionNode] contentOffset].y;
    
    if (currentOffset == 0) {
        return;
    }
    if (currentOffset < 5) {
        currentOffset = 0;
    }
    
    CGFloat offset = [[self node] bounds].size.width;
    currentOffset = currentOffset - offset;
    
    CGFloat duration = 0.05;
//    if ([self currentIndex] < 3) {
//        duration = 0.2;
//    }
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        [[self collectionNode] setContentOffset:CGPointMake(currentOffset, yOffset)];
    } completion:^(BOOL finished) {
        [self animateCollectionView];
    }];
}

- (NSUInteger)currentIndex {
    return [[[[[self collectionNode] visibleNodes] firstObject] indexPath] item];
}

- (NSUInteger)deleteCurrentPhoto {
    NSUInteger currentIndex = [self currentIndex];
    [self deletePhotoAtIndex:currentIndex];
    return currentIndex;
}

- (void)deletePhotoAtIndex:(NSUInteger)index {
    NSMutableArray *mutablePhotos = [[self photos] mutableCopy];
    [mutablePhotos removeObjectAtIndex:index];
    _photos = mutablePhotos;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [[self collectionNode] deleteItemsAtIndexPaths:@[indexPath]];
    
    if ([[self photos] count] == 0) {
        [self close];
    }
}

- (ASCollectionNode *)collectionNode {
    if (!_collectionNode) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [layout setMinimumLineSpacing:0];
        [layout setMinimumInteritemSpacing:0];
        
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        [_collectionNode setAlwaysBounceVertical:NO];
        [_collectionNode setAlwaysBounceHorizontal:YES];
        [_collectionNode setDataSource:self];
        [_collectionNode setDelegate:self];
        [[_collectionNode view] setPagingEnabled:YES];
        [_collectionNode setBackgroundColor:[UIColor blackColor]];
//        
//        ASRangeTuningParameters params = ASRangeTuningParametersZero;
//        params.leadingBufferScreenfuls = 10;
//        params.trailingBufferScreenfuls = 1;
//
//        [_collectionNode setTuningParameters:params forRangeType:ASLayoutRangeTypePreload];
    }
    
    return _collectionNode;
}

- (instancetype)init {
    self = [super initWithNode:[self collectionNode]];
    if (self) {
        viewTranslation = CGPointZero;
        
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
        [[self node] setBackgroundColor:[UIColor blackColor]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapped:)];
        [tapGesture setNumberOfTapsRequired:1];
        [[[self node] view] addGestureRecognizer:tapGesture];
        
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(dismiss:)];
        [gestureRecognizer setCancelsTouchesInView:NO];
        [gestureRecognizer setDelaysTouchesBegan:YES];
        [gestureRecognizer setDelegate:self];
        
//        [[[self node] view] addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)tapped:(UITapGestureRecognizer *)recognizer {
    if ([self isBarHidden]) {
        [[[self navigationController] navigationBar] setAlpha:1];
    } else {
        [[[self navigationController] navigationBar] setAlpha:0];
    }
    
    [self setIsBarHidden:![self isBarHidden]];
}

- (void)viewPhotos:(NSArray *)photos withSelectedIndex:(NSUInteger )index {
    [self setIndexToShow:index];
    
    _photos = photos;
    [[self collectionNode] reloadData];

    [self present];
}

- (void)viewPhotos:(NSArray *)photos {
    [self setPhotos:photos];
    
    [self present];
}

- (void)present {
    NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:self];
    [navCtrl setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navCtrl
                                                                                     animated:YES
                                                                                   completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self navigationItem] setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
    [self addCloseButton];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self collectionNode] setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width*[self indexToShow], - [[self view] safeAreaInsets].top)];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}

- (void)close {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:[self view]];

    if (translation.x > translation.y) {
        NO;
    }

    return YES;
}

- (void)dismiss:(UIPanGestureRecognizer *)sender {
    switch ([sender state]) {
        case UIGestureRecognizerStateChanged: {
            viewTranslation = [sender translationInView:[self view]];
            
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                [[self view] setTransform:CGAffineTransformMake(1, 0, 0, 1, 0, self->viewTranslation.y)];
            } completion:nil];
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            if (viewTranslation.y < 100) {
                [UIView animateWithDuration:0.5
                                      delay:0
                     usingSpringWithDamping:0.7
                      initialSpringVelocity:1
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                    [[self view] setTransform:CGAffineTransformIdentity];
                } completion:nil];
            } else {
                [self close];
            }
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [[self photos] count];
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willDisplayItemWithNode:(ASCellNode *)node {
    NSIndexPath *indexPath = [node indexPath];
    
    if ([self titleForIndex] && [self subtitleForIndex]) {
        NSString *title = [self titleForIndex]([indexPath item]);
        NSString *subtitle = [self subtitleForIndex]([indexPath item]);
        
        [self setNavTitle:title subtitle:subtitle];
    } else if ([self titleForIndex]) {
        NSString *title = [self titleForIndex]([indexPath item]);
        [self setNavTitle:title];
    }
    
    PhotoViewerCellNode *cell = (PhotoViewerCellNode *)node;
    [cell displayPhoto];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *photo = [[self photos] objectAtIndex:[indexPath item]];
    
    ASCellNode *cell = [[PhotoViewerCellNode alloc] initWithPhotoName:photo];
    
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        return cell;
    };
    
    return cellNodeBlock;
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake([collectionNode frame].size.width, [collectionNode frame].size.height);
    return ASSizeRangeMake(size);
}

- (BOOL)shouldBatchFetchForCollectionNode:(ASCollectionNode *)collectionNode {
    if ([self hasMorePhotos]) {
        return [self hasMorePhotos]();
    }
    
    return NO;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    if ([self willBatchFetch]) {
        [self willBatchFetch]();
    }
    [context completeBatchFetching:YES];
}

@end
