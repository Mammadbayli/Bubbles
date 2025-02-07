//
//  CertificatePinningURLSessionDelegate.m
//  Bubbles
//
//  Created by Javad on 04.06.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "CertificatePinningURLSessionDelegate.h"

@implementation CertificatePinningURLSessionDelegate
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    SecTrustRef trust = [[challenge protectionSpace] serverTrust];
    NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];
    
    
    NSString *certFile = @"bubbles";
//    BOOL remoteCertMatchesPinnedCert = false;
    
    NSString *certPath = [[NSBundle mainBundle] pathForResource:certFile ofType:@"der"];
    
    if (!certPath) {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        return;
    }
    
    NSData *certData = [NSData dataWithContentsOfFile:certPath];
    if (!certData) {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        return;
    }
    
    NSData *remoteCertData = CFBridgingRelease(SecCertificateCopyData(SecTrustGetCertificateAtIndex(trust, 0)));
    
    if ([remoteCertData isEqual:certData]) {
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        return;
    }
}

@end
