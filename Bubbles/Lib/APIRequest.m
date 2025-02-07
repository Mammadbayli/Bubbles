//
//  APIRequest.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 05.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "APIRequest.h"
#import "Constants.h"
#import "BundleLocalization.h"

@implementation APIRequest
- (NSString *)currentLocale {
    return [[BundleLocalization sharedInstance] language];
}
+ (instancetype)GETRequestWithPath:(NSString *)path {
    APIRequest *request = [[APIRequest alloc] initWithPath:path];
    
    [request setHTTPMethod:@"GET"];
    
    return request;
}

+ (instancetype)POSTRequestWithPath:(NSString *)path andData:(nonnull NSDictionary *)data {
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    APIRequest *request = [[APIRequest alloc] initWithPath:path];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPBody:postData];
    
    return request;
}

+ (instancetype)PUTRequestWithPath:(NSString *)path {
    APIRequest *request = [[APIRequest alloc] initWithPath:path];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    return request;
}

+ (instancetype)PATCHRequestWithPath:(NSString *)path {
    APIRequest *request = [[APIRequest alloc] initWithPath:path];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PATCH"];

    return request;
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        NSString *url = [NSString stringWithFormat:@"%@/%@", API_URL, path];
        [self setURL:[NSURL URLWithString:url]];
        [self addAuthorizationHeader];
        [self addAcceptLanguageHeader];
    }
    return self;
}

- (void)addAuthorizationHeader {
    [self setValue:@"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJNYW1tYWRiYXlsaSIsImlhdCI6MTYwNDI0NjUxNSwiZXhwIjoxOTUxNTc0NTE1LCJhdWQiOiJhcGkubWFtbWFkYmF5bGkuY29tIiwic3ViIjoiamF2YWRAbWFtbWFkYmF5bGkuY29tIn0.fb1Vy5DzmaExiRoNAEWlB4F46KyLv2oO9acDNpTF7Us" forHTTPHeaderField:@"Authorization"];
}

- (void)addAcceptLanguageHeader {
    [self setValue:[self currentLocale] forHTTPHeaderField:@"Accept-Language"];
}

+ (instancetype)DELETERequestWithPath:(NSString *)path andData:(nullable NSDictionary *)data {
    APIRequest *request = [[APIRequest alloc] initWithPath:path];
    [request setHTTPMethod:@"DELETE"];
    
    if (data) {
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
    }
    
    return request;
}

@end
