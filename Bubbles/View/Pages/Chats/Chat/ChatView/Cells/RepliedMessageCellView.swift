//
//  RepliedMessageCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/29/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct RepliedMessageCellView: View {
    private var message: ChatMessage
    
    var body: some View {
        VStack(alignment: .leading) {
            LocalizedText(message.senderTitle)
                .font(.defaultText)
                .foregroundStyle(.nfsGreen)
            
            messageBody
        }
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(.nfsGray)
        .cornerRadius(.messageBubbleCornerRadius, corners: .allCorners)
    }
    
    @ViewBuilder
    private var messageBody: some View {
        switch message._type {
        case .text, .unknown:
            Text(message.body ?? "")
                .font(.defaultText)
                .foregroundStyle(.defaultText)
        case .photo:
            HStack {
                Text("📷")
                    .font(.defaultText)
                    .foregroundStyle(.defaultText)
                    
                LocalizedText("photo_message_body")
                    .font(.defaultText)
                    .foregroundStyle(.defaultText)
            }
        case .voice:
            HStack {
                Text("🎤")
                    .font(.defaultText)
                    .foregroundStyle(.defaultText)
                    
                LocalizedText("voice_message_body")
                    .font(.defaultText)
                    .foregroundStyle(.defaultText)
            }
        case .sharedPost:
            HStack {
                Text("✉️")
                    .font(.defaultText)
                    .foregroundStyle(.defaultText)
                    
                LocalizedText(message.post?.title ?? "")
                    .font(.defaultText)
                    .foregroundStyle(.defaultText)
            }
        }
    }
    
    init(message: ChatMessage) {
        self.message = message
    }
}
