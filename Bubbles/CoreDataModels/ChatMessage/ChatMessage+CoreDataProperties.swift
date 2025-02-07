//
//  ChatMessage+CoreDataProperties.swift
//  
//
//  Created by Javad Mammadbayli on 7/22/24.
//
//

import Foundation
import CoreData


extension ChatMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessage> {
        return NSFetchRequest<ChatMessage>(entityName: "ChatMessage")
    }

    @NSManaged public var deliveryStatus: String?
    @NSManaged public var isForwarded: Bool
    @NSManaged public var chat: Chat?
    @NSManaged public var forwardedMessage: ChatMessage?
    @NSManaged public var forwardingMessage: ChatMessage?
    @NSManaged public var post: Post?

}
