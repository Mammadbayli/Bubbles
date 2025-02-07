//
//  ChatMessage+CoreDataClass.swift
//  
//
//  Created by Javad Mammadbayli on 7/22/24.
//
//

import Foundation
import CoreData
import XMPPFramework

@objc(ChatMessage)
public class ChatMessage: Message {
    public override var xmlRepresentation: XMPPMessage {
        let xmppMessage = super.xmlRepresentation
        guard let jid = to?.jid().full else { return xmppMessage }
        xmppMessage.addAttribute(withName: "type", stringValue: "chat")
        xmppMessage.addAttribute(withName: "to", stringValue: jid)
        xmppMessage.isForwarded = isForwarded
        if let forwardedMessage {
            let element = XMLElement(name: "forwarded", xmlns: "urn:xmpp:forward:0")
            element.addChild(forwardedMessage.xmlRepresentation)
            xmppMessage.addChild(element)
        }
        
        return xmppMessage
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public override init(xmppMessage: XMPPMessage, andContext context: NSManagedObjectContext) {
        super.init(xmppMessage: xmppMessage, andContext: context)
        to = xmppMessage.to?.user
        isForwarded = xmppMessage.isForwarded
        deliveryStatus = MESSAGE_STATUS_NONE
        chat = Chat.getWithUser(from, using: context)
        if let fowardedMessageId = xmppMessage.forwardedMessage?.messageId {
            forwardedMessage = ChatMessage.find(withMessageId: fowardedMessageId, usingContext: context)
        }
    }
    
    public override func markAsRead() {
        super.markAsRead(completionBlock: nil)
        XMPPController.sharedInstance().sendReadReceipt(for: self)
    }
    
    public override var notificationTitle: String {
        chatId?.uppercased() ?? "Message"
    }
}

@objc
extension ChatMessage {
    var sectionTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "dd.MM.YYYY"

        return dateFormatter.string(from: timestamp)
    }
    
    var chatId: String? {
        chat?.chatId
    }
    
    static func with(xmppMessage: XMPPMessage, andContext context: NSManagedObjectContext) -> ChatMessage {
        return switch xmppMessage.customTypeEnum {
        case .audio:
            VoiceMessage(xmppMessage: xmppMessage, andContext: context)
        case .photo:
            PhotoMessage(xmppMessage: xmppMessage, andContext: context)
        case .post:
            PostMessage(xmppMessage: xmppMessage, andContext: context)
        case .text, .none:
            TextMessage(xmppMessage: xmppMessage, andContext: context)
        }
    }
    
    static func forwardedMessageWith(message: ChatMessage, andContext context: NSManagedObjectContext) -> ChatMessage {
        let newMessage = message.copy(with: context)
        newMessage.forwardedMessage = context.object(with: message.objectID) as? ChatMessage
        return newMessage
    }
    
    static func updateDeliveryStatus(_ status: String, forMessageId messageId: String, usingContext context: NSManagedObjectContext) {
        context.perform {
            if let message = self.find(withMessageId: messageId, usingContext: context) {
                message.deliveryStatus = status
                CoreDataStack.sharedInstance().saveContextThreadUnsafe(context, error: nil)
                if let chatObjectId = message.chat?.objectID {
                    let mainContext = CoreDataStack.sharedInstance().mainContext
                    mainContext.perform {
                        let chat = mainContext.object(with: chatObjectId)
                        mainContext.refresh(chat, mergeChanges: true)
                    }
                }
            }
        }
    }
    
    static func updateStarred(_ starred: Bool, forMessageId messageId: String) {
        let context = CoreDataStack.sharedInstance().backgroundContext
        context.perform {
            if let message = self.find(withMessageId: messageId, usingContext: context) {
                message.isStarred = starred
                CoreDataStack.sharedInstance().saveContextThreadUnsafe(context, error: nil)
            }
        }
    }
    
    static func find(withMessageId messageId: String, usingContext context: NSManagedObjectContext) -> ChatMessage? {
        let request = NSFetchRequest<ChatMessage>(entityName: "ChatMessage")
        request.predicate = NSPredicate(format: "uniqueId == %@", messageId)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    @objc
    func copy(with context: NSManagedObjectContext) -> ChatMessage {
        ChatMessage.init(context: context)
    }
}

extension XMPPMessage {
    enum CustomType: String {
        case post
        case audio
        case photo
        case text
        case none
    }
    
    var customTypeEnum: CustomType {
        CustomType(rawValue: customType) ?? .none
    }
}
