//
//  Chat+CoreDataProperties.swift
//  
//
//  Created by Javad Mammadbayli on 7/20/24.
//
//

import Foundation
import CoreData

extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var chatId: String?
    @NSManaged public var isComposing: Bool
    @NSManaged public var isOnline: Bool
    @NSManaged public var unreadCount: Int16
    @NSManaged public var latestMessage: ChatMessage?
    @NSManaged public var messages: NSOrderedSet?

}

// MARK: Generated accessors for messages
extension Chat {

    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged public func insertIntoMessages(_ value: ChatMessage, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged public func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged public func insertIntoMessages(_ values: [ChatMessage], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged public func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged public func replaceMessages(at idx: Int, with value: ChatMessage)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged public func replaceMessages(at indexes: NSIndexSet, with values: [ChatMessage])

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: ChatMessage)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: ChatMessage)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSOrderedSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSOrderedSet)

}
