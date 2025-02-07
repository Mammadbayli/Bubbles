//
//  ChatViewModel+CoreDataObserver.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/4/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

extension ChatViewModel {
    func registerCoreDataObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveUpdate(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    @objc
    private func didReceiveUpdate(notification: Notification) {
        guard
            let context = notification.object as? NSManagedObjectContext,
            let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<ChatMessage>,
            let newMessage = insertedObjects.first (where: { $0.chatId == chatId && !$0.isOutgoing })
        else { return }
        
        let id = newMessage.uniqueId
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.latestMessageId = id
        }
    }
}
