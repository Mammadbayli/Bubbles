//
//  PhotoMessage.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/13/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@objc(PhotoMessage)
class PhotoMessage: ChatMessage {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PhotoMessage> {
        return NSFetchRequest<PhotoMessage>(entityName: "PhotoMessage")
    }
    
    override init(xmppMessage: XMPPMessage, andContext context: NSManagedObjectContext) {
        super.init(xmppMessage: xmppMessage, andContext: context)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override var xmlRepresentation: XMPPMessage {
        let xmppMessage = super.xmlRepresentation
        xmppMessage.customType = ChatMessage.MessageType.photo.rawValue
        return xmppMessage
    }
    
    override func copy(with context: NSManagedObjectContext) -> ChatMessage {
        let message = PhotoMessage(context: context)
        message.body = body
        if let files = files?.array as? [File] {
            for file in files {
                message.addFilesObject(file.copy(with: context))
            }
        }
        
        return message
    }
}
