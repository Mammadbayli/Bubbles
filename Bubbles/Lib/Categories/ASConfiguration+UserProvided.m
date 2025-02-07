//
//  ASConfiguration+UserProvided.m
//  Bubbles
//
//  Created by Javad on 24.04.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import "ASConfiguration+UserProvided.h"

@implementation ASConfiguration (UserProvided)
+ (ASConfiguration *)textureConfiguration {
    ASConfiguration *conf = [[ASConfiguration alloc] initWithDictionary:nil];
    [conf setExperimentalFeatures:ASExperimentalDisableGlobalTextkitLock];
    
    return conf;
}
@end
