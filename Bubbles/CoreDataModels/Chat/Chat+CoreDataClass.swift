//
//  Chat+CoreDataClass.swift
//  
//
//  Created by Javad Mammadbayli on 7/20/24.
//
//

import Foundation
import CoreData

@objc(Chat)
public class Chat: NSManagedObject {
    @objc
    static func getWithUser(_ username: String?, using context: NSManagedObjectContext) -> Chat? {
        guard let username = username?.lowercased() else { return nil }
        let request = Chat.fetchRequest()
        request.predicate = NSPredicate(format: "(chatId == %@)", username)
        request.fetchLimit = 1
        
        guard
            let results = try? context.fetch(request),
            let chat = results.first
        else {
            return Chat.initWithUsername(username, andContext: context)
        }
        
        return chat
    }
    
    @objc
    static func deleteChat(withChatId chatId: String?,  using context: NSManagedObjectContext) {
        guard let chat = getWithUser(chatId, using: context) else { return }
        CoreDataStack.sharedInstance().delete(chat, using: context)
    }
}

@objc
extension Chat {
    static func initWithUsername(_ username: String, andContext context: NSManagedObjectContext) -> Chat {
        let chat = Chat(context: context)
        chat.chatId = username
        return chat
    }
}

