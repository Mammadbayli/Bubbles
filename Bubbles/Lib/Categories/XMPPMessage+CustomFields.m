//
//  XMPPMessage+CustomFields.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "XMPPMessage+CustomFields.h"
#import "Constants.h"

@implementation XMPPMessage (CustomFields)
- (NSString *)messageId {
    return [self attributeStringValueForName:@"id"];
}

- (void)setMessageId:(NSString *)messageId {
    [self addAttributeWithName:@"id" stringValue:messageId];
}

- (NSDate *)timestamp {
    NSUInteger timestamp = [[self dataElement] attributeUnsignedIntegerValueForName:MESSAGE_ATTRIBUTE_TIMESTAMP];
    timestamp = timestamp / 1000;
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

- (void)setTimestamp:(NSDate *)timestamp {
    NSUInteger seconds = [timestamp timeIntervalSince1970] * 1000;
    [[self dataElement] addAttributeWithName:MESSAGE_ATTRIBUTE_TIMESTAMP unsignedIntegerValue:seconds];
}

- (BOOL)isForwarded {
    return [[self dataElement] attributeBoolValueForName:MESSAGE_ATTRIBUTE_IS_FORWARDED withDefaultValue:NO];
}

- (void)setIsForwarded:(BOOL)isForwarded {
    [[self dataElement] addAttributeWithName:MESSAGE_ATTRIBUTE_IS_FORWARDED boolValue:isForwarded];
}

- (NSString *)customType {
    return  [[self dataElement] attributeStringValueForName:MESSAGE_ATTRIBUTE_TYPE withDefaultValue:MESSAGE_TYPE_TEXT];
}

- (void)setCustomType:(NSString *)customType {
    [[self dataElement] addAttributeWithName:MESSAGE_ATTRIBUTE_TYPE stringValue:customType];
}

- (NSString *)parentId {
    return [[self parentElement] attributeStringValueForName:@"parent_id"];
}

- (void)setParentId:(NSString *)parentId {
    [[self parentElement] addAttributeWithName:MESSAGE_ATTRIBUTE_PARENT_ID stringValue:parentId];
}

- (void)setParent:(NSXMLElement *)parent {
    [[self parentElement] addChild:parent];
}

- (NSXMLElement *)parent {
    return [[self parentElement] elementForName:@"message"];
}

- (BOOL)isComment {
    return [self isGroupChatMessage] && [self elementForName:@"parent"];
}

- (BOOL)isPost {
    return [self isGroupChatMessage] && ![self isComment];
}

- (NSArray<NSDictionary *> *)files {
    NSMutableArray *files = [[NSMutableArray alloc] init];
    NSArray *children = [[self filesElement] children];
    
    for (DDXMLElement *child in children) {
        NSString *name = [child attributeStringValueForName:MESSAGE_FILE_ATTRIBUTE_NAME];
        NSString *type = [child attributeStringValueForName:MESSAGE_FILE_ATTRIBUTE_TYPE];
        
        if (name) {
            [files addObject:@{@"name": name, @"type": type}];
        }
    }
    
    return files;
}

- (NSXMLElement *)dataElement {
    NSXMLElement *element = [self elementForName:MESSAGE_DATA];
    
    if(!element) {
        element = [NSXMLElement elementWithName:MESSAGE_DATA xmlns:@"urn:xmpp:data"];
        [self addChild:element];
    }
    
    return element;
}

- (void)addFile:(NSString *)fileName withType:(NSString *)type {
    NSXMLElement *element = [NSXMLElement elementWithName:MESSAGE_FILE xmlns:@"message:file"];
//    [element setStringValue:fileName];
    [element addAttributeWithName:MESSAGE_FILE_ATTRIBUTE_NAME stringValue:fileName];
    [element addAttributeWithName:MESSAGE_FILE_ATTRIBUTE_TYPE stringValue:type];
    [[self filesElement] addChild:element];
}

- (NSXMLElement *)filesElement {
    NSXMLElement *element = [self elementForName:MESSAGE_FILES];
    
    if(!element) {
        element = [NSXMLElement elementWithName:MESSAGE_FILES xmlns:@"urn:xmpp:files"];
        [self addChild:element];
    }
    
    return element;
}

- (NSXMLElement *)parentElement {
    NSXMLElement *element = [self elementForName:MESSAGE_PARENT];
    
    if(!element) {
        element = [NSXMLElement elementWithName:MESSAGE_PARENT xmlns:@"urn:xmpp:parent"];
        [self addChild:element];
    }
    
    return element;
}
@end
