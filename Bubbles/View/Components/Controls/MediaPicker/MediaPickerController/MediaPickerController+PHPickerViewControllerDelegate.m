//
//  MediaPickerController+PHPickerViewControllerDelegate.m
//  Bubbles
//
//  Created by Javad on 06.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "MediaPickerController+PHPickerViewControllerDelegate.h"
#import "MediaPickerPhotoCellItem.h"
#import "ActivityIndicatorPresenter.h"

@import PromiseKit;

@implementation MediaPickerController (PHPickerViewControllerDelegate)
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results  API_AVAILABLE(ios(14)){
    if ([results count] == 0) {
        [self mediaPickerControllerDidCancel];
        return;
    }
    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *promises = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [results count]; i++) {
        PHPickerResult *result = [results objectAtIndex:i];
        NSItemProvider *provider = [result itemProvider];
        
        [[ActivityIndicatorPresenter sharedInstance] present];
        
        AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
            if ([provider canLoadObjectOfClass:[UIImage class]]) {
                [provider loadObjectOfClass:[UIImage class]
                          completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                    resolve((UIImage *)object);
                }];
            }
        }];
        
        [promises addObject:promise];
    }
    
    PMKWhen(promises)
        .then(^(NSArray *photos) {
            [self setItems:[photos mutableCopy]];
            [self pickerDidFinishPicking:photos];
            
            [[ActivityIndicatorPresenter sharedInstance] dismiss];
        });
}
@end
