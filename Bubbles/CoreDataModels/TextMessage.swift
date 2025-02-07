//
//  TextMessage.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/13/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@objc(TextMessage)
class TextMessage: ChatMessage {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TextMessage> {
        return NSFetchRequest<TextMessage>(entityName: "TextMessage")
    }
    
    override init(xmppMessage: XMPPMessage, andContext context: NSManagedObjectContext) {
        super.init(xmppMessage: xmppMessage, andContext: context)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override var xmlRepresentation: XMPPMessage {
        let xmppMessage = super.xmlRepresentation
        xmppMessage.customType = ChatMessage.MessageType.text.rawValue
        return xmppMessage
    }
    
    override func copy(with context: NSManagedObjectContext) -> ChatMessage {
        let message = TextMessage(context: context)
        message.body = body

        return message
    }
}
