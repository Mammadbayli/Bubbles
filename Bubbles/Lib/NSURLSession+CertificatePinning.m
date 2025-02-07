//
//  NSURLSession+CertificatePinning.m
//  Bubbles
//
//  Created by Javad on 04.06.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "NSURLSession+CertificatePinning.h"
#import "CertificatePinningURLSessionDelegate.h"

@implementation NSURLSession (CertificatePinning)
+ (NSURLSession *)certificatePinnedSession {
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
//                                                          delegate:[[CertificatePinningURLSessionDelegate alloc] init]
//                                                     delegateQueue:nil];
    
    return [NSURLSession sharedSession];//disable cert pinning
}
@end
