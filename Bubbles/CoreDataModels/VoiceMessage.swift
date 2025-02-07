//
//  VoiceMessage.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/13/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@objc(VoiceMessage)
class VoiceMessage: ChatMessage {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<VoiceMessage> {
        return NSFetchRequest<VoiceMessage>(entityName: "VoiceMessage")
    }
    
    @NSManaged var duration: Double
    
    override init(xmppMessage: XMPPMessage, andContext context: NSManagedObjectContext) {
        super.init(xmppMessage: xmppMessage, andContext: context)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        guard let file = (self.files?.firstObject as? File), let context, duration == -1 else { return }
        let messageId = self.uniqueId
        file.download().pipe { result in
            switch result {
            case .fulfilled(let data):
                if let data = data as? Data {
                    context.perform {
                        if let message =  Message.findMessage(withMessageId: messageId, using: context) as? VoiceMessage {
                            message.duration = AVController.sharedInstance().durationForAudio(with: data)
                            CoreDataStack.sharedInstance().save(context)
                        }
                    }
                }
            case .rejected(let error):
                print(error)
            }
        }
    }
    
    override var xmlRepresentation: XMPPMessage {
        let xmppMessage = super.xmlRepresentation
        xmppMessage.customType = ChatMessage.MessageType.voice.rawValue
        return xmppMessage
    }
    
    override func setFilesArray(_ files: [Any], withType type: String) {
        super.setFilesArray(files, withType: type)
        
        guard let data = files.first as? Data else { return }
        duration = AVController().durationForAudio(with: data)
    }
    
    override func copy(with context: NSManagedObjectContext) -> ChatMessage {
        let message = VoiceMessage(context: context)
        
        if let files = files?.array as? [File] {
            for file in files {
                message.addFilesObject(file.copy(with: context))
            }
        }
        
        return message
    }
}
