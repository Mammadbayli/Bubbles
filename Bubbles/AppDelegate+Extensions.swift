//
//  AppDelegate+Extensions.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/20/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let navigateToChat = Notification.Name(rawValue: NAVIGATE_TO_CHAT)
    static let navigateToRoster = Notification.Name(rawValue: NAVIGATE_TO_ROSTER)
    static let navigateToPost = Notification.Name(rawValue: NAVIGATE_TO_POST)
}

@objc
extension AppDelegate {
    func navigateToChatWithUser(_ username: String?) {
        guard
            let username = username?.lowercased(),
            username != currentChat
        else { return }
        
        let block = {
            NotificationCenter.default.post(name: .navigateToChat,
                                            object: nil,
                                            userInfo: ["chatId": username])
        }
        
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    func navigateToPostWithId(_ postId: String?) {
        guard
            let postId,
            postId != currentPost
        else { return }
        
        let block = {
            NotificationCenter.default.post(name: .navigateToPost,
                                            object: nil,
                                            userInfo: ["postId": postId])
        }
        
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    func navigateToRoster() {
        let block = {
            NotificationCenter.default.post(name: .navigateToRoster,
                                            object: nil,
                                            userInfo: nil)
        }
        
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    func navigateToUsernameChange() {
        let block = {
//            NotificationCenter.default.post(name: .navigateToRoster,
//                                            object: nil,
//                                            userInfo: nil)
        }
        
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
