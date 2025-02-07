//
//  XMPPMessage+CustomFields.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <XMPPFramework/XMPPFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMPPMessage (CustomFields)

@property (strong, nonatomic) NSString *messageId;
@property (strong, nonatomic, readonly) NSArray<NSDictionary *> *files;
@property (strong, nonatomic) NSDate *timestamp;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSXMLElement *parent;
@property (strong, nonatomic) NSString *customType;
@property (nonatomic) BOOL isForwarded;
@property (nonatomic) BOOL isPost;
@property (nonatomic) BOOL isComment;

- (void)addFile:(NSString *)fileName withType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
