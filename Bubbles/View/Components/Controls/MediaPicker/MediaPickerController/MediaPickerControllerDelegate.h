//
//  MediaPickerControllerDelegate.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/23/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MediaPickerControllerDelegate <NSObject>
@optional
- (void)mediaPickerControllerDidFinishPicking:(NSArray *)media andText:(NSString *)text;
- (void)mediaPickerControllerDidCancel;
@end
