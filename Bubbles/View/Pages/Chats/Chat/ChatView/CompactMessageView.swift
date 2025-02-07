//
//  CompactMessageView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/1/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import CoreData
import SwiftUI

struct CompactMessageView: View {
    private let message: ChatMessage
    private var onCancel: (() -> Void)?
    
    var body: some View {
        VStack(spacing: .zero) {
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(.black.opacity(0.6))
            
            HStack {
                Rectangle()
                    .foregroundStyle(.nfsGreen)
                    .frame(width: 4)
    //                .fixedSize()
                
                VStack(alignment: .leading) {
                    Text(message.from?.uppercased() ?? "")
                        .font(.defaultText)
                        .foregroundStyle(.nfsGreen)
                    
                    messageBody
                }
                
                Spacer()
                
                Button {
                    onCancel?()
                } label: {
                    Image(systemName: "xmark.circle")
                         .resizable()
                         .renderingMode(.template)
                         .foregroundStyle(.nfsGreen)
                         .fixedSize()
                         .padding(.trailing)
                }
            }
        }
        .frame(height: 40)
        .background(.defaultBackground)
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
                
//                LocalizedText(message.post?.title ?? "")
//                    .font(.defaultText)
//                    .foregroundStyle(.defaultText)
            }
        }
    }
    
    init(message: ChatMessage, onCancel: (() -> Void)? = nil) {
        self.message = message
        self.onCancel = onCancel
    }
}
