//
//  APIRequest.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 05.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIRequest : NSMutableURLRequest
+ (instancetype)GETRequestWithPath:(NSString *)path;
+ (instancetype)POSTRequestWithPath:(NSString *)path andData:(NSDictionary *)data;
+ (instancetype)PUTRequestWithPath:(NSString *)path;
+ (instancetype)DELETERequestWithPath:(NSString *)path andData:(nullable NSDictionary *)data;
+ (instancetype)PATCHRequestWithPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
