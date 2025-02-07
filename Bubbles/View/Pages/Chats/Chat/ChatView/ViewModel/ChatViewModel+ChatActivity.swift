//
//  ChatViewModel+ChatActivity.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/1/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import Foundation

extension ChatViewModel {
    func registerLastActivityObersvers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userWentOnline(notif:)),
                                               name:Notification.Name(USER_ONLINE_NOTIFICATION),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userWentOffline(notif:)),
                                               name:Notification.Name(USER_OFFLINE_NOTIFICATION),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveLastActivity(notif:)),
                                               name:Notification.Name(XMPP_STREAM_DID_RECEIVE_LAST_ACTIVITY_RESULT),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveLastActivityError(notif:)),
                                               name:Notification.Name(XMPP_STREAM_DID_RECEIVE_LAST_ACTIVITY_ERROR),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userStartedComposing(notif:)),
                                               name:Notification.Name(USER_COMPOSING_NOTIFICATION),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userPausedComposing(notif:)),
                                               name:Notification.Name(USER_PAUSED_COMPOSING_NOTIFICATION),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didAuthenticate(notif:)),
                                               name:Notification.Name(XMPP_STREAM_DID_AUTHENTICATE_NOTIFICATION),
                                               object: nil)
    }
    
    @objc
    private func userWentOnline(notif: Notification) {
        guard let username = notif.userInfo?["jid"] as? String,
              username == chatId else { return }
        
        DispatchQueue.main.async {
            self.chatActivityStatus = "last_activity.online".localized
        }
    }
    
    @objc
    private func userWentOffline(notif: Notification) {
        guard let username = notif.userInfo?["jid"] as? String,
              username == chatId else { return }
        
        DispatchQueue.main.async {
            self.chatActivityStatus = "last_activity.offline".localized
        }
    }
    
    @objc
    private func didReceiveLastActivity(notif: Notification) {
        guard let username = notif.userInfo?["jid"] as? String,
              username == chatId,
        let seconds = notif.userInfo?["seconds"] as? Int else { return }

        DispatchQueue.main.async {
            self.chatActivityStatus = seconds.lastSeen.localized
        }
    }
    
    @objc
    private func didReceiveLastActivityError(notif: Notification) {
        guard let username = notif.userInfo?["jid"] as? String,
              username == chatId else { return }
        
    }
    
    @objc
    private func userStartedComposing(notif: Notification) {
        guard let username = notif.userInfo?["jid"] as? String,
              username == chatId else { return }
        
        DispatchQueue.main.async {
            self.chatActivityStatus = "chat.status.typing".localized;
        }
    }
    
    @objc
    private func userPausedComposing(notif: Notification) {
        guard let username = notif.userInfo?["jid"] as? String,
              username == chatId else { return }
        
        DispatchQueue.main.async {
            self.chatActivityStatus = "last_activity.online".localized
        }
    }
    
    @objc
    private func didAuthenticate(notif: Notification) {
        //Temporary measure to address possible race condition
        DispatchQueue.main.async {
            XMPPController.sharedInstance().sendLastActivityQuery(toUser: self.chatId)
        }
    }
}

extension Int {
    var lastSeen: String {
        NSString.convertSeconds(toHumanReadableString: Int32(self))
    }
}
