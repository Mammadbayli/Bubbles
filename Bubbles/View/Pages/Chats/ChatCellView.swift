//
//  ChatCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/10/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct ChatCellView: View {
    @ObservedObject private var chat: Chat
    
    var body: some View {
        HStack(alignment: .center) {
            if let chatId = chat.chatId {
                SelfDownloadingAvatarView(username: chatId)
                
                VStack(alignment: .leading) {
                    Text(chatId.uppercased())
                        .font(.chatCellTitle)
                        .foregroundStyle(.defaultText)
                    
                    Text(chat.latestMessage?.textRepresentation ?? "")
                        .font(.chatCellSubtitle)
                        .foregroundStyle(.lightText)
                }
            }
            
            Spacer()
            
            if chat.unreadCount > 0 {
                BadgeView(label: String(chat.unreadCount))
            }
            
            VStack(alignment: .trailing) {
                chat.latestMessage?.timestampView
                chat.latestMessage?.deliveryReceiptView
            }
            .scaleEffect(CGSize(width: 1.2, height: 1.2))
        }
        .frame(maxHeight: 40)
        .onAppear {
            LoggerController.sharedInstance().log("chatId: " + (chat.chatId ?? "no chat id"))
        }
    }
    
    init(chat: Chat) {
        self.chat = chat
    }
}
