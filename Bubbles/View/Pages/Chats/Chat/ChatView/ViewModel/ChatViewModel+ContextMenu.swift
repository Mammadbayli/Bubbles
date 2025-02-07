//
//  ChatViewModel+ContextMenu.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/31/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

extension ChatViewModel {
    @ViewBuilder 
    func contextMenu(for message: ChatMessage) -> some View {
//        Button {
//            message.setStarred(!message.isStarred)
//            message.save()
//        } label: {
//            Image(systemName: message.isStarred ?  "star.slash.fill" : "star")
//            Text(message.isStarred ? "unsave".localized : "save".localized)
//        }

        if message.isTextMessage {
            Button {
                UIPasteboard.general.string = message.body
            } label: {
                Image(systemName: "doc.on.doc")
                Text("copy".localized)
            }
        }

        Button {
            withAnimation {
                self.messageIdBeingRepliedTo = message.objectID
            }
  
        } label: {
            Image(systemName: "arrowshape.turn.up.backward")
            Text("reply".localized)
        }
        
        Button {
            BuddySelector.sharedInstance().select(withMultipleOption: true).pipe { result in
                switch result {
                case .fulfilled(let usernames):
                    if let usernames = usernames as? Set<String> {
                        for username in usernames {
                            guard let context = message.managedObjectContext else { continue }
                            let forwardedMessage = message.copy(with: context)
                            forwardedMessage.isForwarded = true
                            forwardedMessage.to = username
                            let chat = Chat.getWithUser(username, using: context)
                            forwardedMessage.chat = chat
                            forwardedMessage.send()
                        }
                    }
                case .rejected(let error):
                    print(error)
                }
            }
        } label: {
            Image(systemName: "arrowshape.turn.up.forward")
            Text("forward".localized)
        }
        
        Button {
            if let context = message.managedObjectContext {
                context.delete(message)
                CoreDataStack.sharedInstance().save(context)
            }
        } label: {
            Image(systemName: "trash")
            Text("delete".localized)
        }
    }
}
