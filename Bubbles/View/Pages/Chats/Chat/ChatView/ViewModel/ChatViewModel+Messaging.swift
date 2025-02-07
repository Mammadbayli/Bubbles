//
//  ChatViewModel+Messaging.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/29/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

extension ChatViewModel {
    func sendTextMessage(with text: String) {
        let context = CoreDataStack.sharedInstance().mainContext
        let message = TextMessage(context: context)
        message.body = text
        send(message: message)
    }
    
    func sendPohotMessage(with data: Data, andBody body: String?) {
        let context = CoreDataStack.sharedInstance().mainContext
        let message = PhotoMessage(context: context)
        message.body = body
        message.setFilesArray([data], withType: ChatMessage.MessageType.photo.rawValue)
        send(message: message)
    }

    func sendVoiceMessage(with data: Data) {
        let context = CoreDataStack.sharedInstance().mainContext
        let message = VoiceMessage(context: context)
        message.setFilesArray([data], withType: ChatMessage.MessageType.voice.rawValue)
        send(message: message)
    }
    
    private func send(message: ChatMessage) {
        let context = CoreDataStack.sharedInstance().mainContext
        let chat = Chat.getWithUser(chatId, using: context)
        
        if let objectId = messageIdBeingRepliedTo ,
           let repliedMessage = try? CoreDataStack.sharedInstance().mainContext.existingObject(with: objectId) as? ChatMessage {
            message.forwardedMessage = repliedMessage
            self.messageIdBeingRepliedTo = nil
        }
        
        let id = message.uniqueId
        
        message.to = chatId
        message.chat = chat
        message.send()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.latestMessageId = id
        }
    }
}
