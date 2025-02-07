//
//  ChatViewModel+ViewLifecycle.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/6/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import IQKeyboardManager

extension ChatViewModel {
    func onAppear() {
        XMPPController.sharedInstance().sendLastActivityQuery(toUser: chatId)
        XMPPController.sharedInstance().becomeActive(withChatId: chatId)
        
        IQKeyboardManager.shared().isEnabled = false
        
        (UIApplication.shared.delegate as? AppDelegate)?.currentChat = chatId
    }
    
    func onDisappear() {
        XMPPController.sharedInstance().becomeGone(withChatId: chatId)
        
        IQKeyboardManager.shared().isEnabled = true
        
        (UIApplication.shared.delegate as? AppDelegate)?.currentChat = nil
    }
}

extension ChatViewModel {
    func onMessageCellAppear(message: ChatMessage) {
        message.markAsRead()
        
        let id = message.uniqueId
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            LocalNotificationsController.sharedInstance().removeNotification(withIdentifier: id)
        }
    }
}


