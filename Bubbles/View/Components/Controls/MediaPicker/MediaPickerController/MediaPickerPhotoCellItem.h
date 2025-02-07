//
//  MediaPickerPhotoCellItem.h
//  Bubbles
//
//  Created by Javad on 05.09.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface MediaPickerPhotoCellItem : NSObject
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
