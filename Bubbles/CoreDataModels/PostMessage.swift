//
//  PostMessage.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/13/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import CoreData
import Foundation
import XMPPFramework

@objc(PostMessage)
class PostMessage: ChatMessage {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PostMessage> {
        return NSFetchRequest<PostMessage>(entityName: "PostMessage")
    }
    
    override init(xmppMessage: XMPPMessage, andContext context: NSManagedObjectContext) {
        super.init(xmppMessage: xmppMessage, andContext: context)
        
        guard let xml = xmppMessage.elements(forName: "post").first,
              let postXML = xml.elements(forName: "message").first else { return }
        
        self.post = Post(xmppMessage: XMPPMessage(from: postXML), andContext: context)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override var xmlRepresentation: XMPPMessage {
        let xmppMessage = super.xmlRepresentation
        xmppMessage.customType = ChatMessage.MessageType.sharedPost.rawValue
        
        if let post = self.post {
            let postXML = XMLElement(name: "post", xmlns: "urn:xmpp:forward:0")
            postXML.addChild(post.xmlRepresentation)
            xmppMessage.addChild(postXML)
        }
        
        return xmppMessage
    }
    
    override func copy(with context: NSManagedObjectContext) -> ChatMessage {
        let message = PostMessage(context: context)
        message.post = post
        
        return message
    }
}
