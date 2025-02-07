//
//  ChatMessageCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/29/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct ChatMessageCellView<MenuItems: View>: View {
    @ObservedObject var message: ChatMessage
    @ViewBuilder private var menuItems: () -> MenuItems
    private var onTap: (() -> Void)?
    @Environment(\.onReppliedMessageTap) private var onRepliedMessageTap: (String) -> Void
    
    
    init(message: ChatMessage, 
         @ViewBuilder menuItems: @escaping () -> MenuItems = { EmptyView() },
         onTap: (() -> Void)? = nil) {
        self.message = message
        self.menuItems = menuItems
        self.onTap = onTap
    }
    
    var body: some View {
        HStack {
            if message.isOutgoing {
                Spacer(minLength: UIScreen.main.bounds.width*0.1)
            }

            Menu {
                menuItems()
            } label: {
                messageBubble
                    .foregroundStyle(.defaultText)
            } primaryAction: {
                tapped() // Does not work iOS 17 and below
            }
            .onTapGesture {// For iOS 17 and below, fckin Apple
                tapped()
            }

            if !message.isOutgoing {
                Spacer(minLength: UIScreen.main.bounds.width*0.1)
            }
        }
    }

    private func tapped() {
        onTap?()
        NotificationCenter.default.post(Notification(name: Notification.Name("messageTapped"), // Workaround for Menu primary action overriding any other gestures
                                                     userInfo: ["messageId": message.uniqueId]))
    }

    @ViewBuilder
    private var messageBubble: some View {
        VStack(alignment: .trailing, spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {
                if message.isForwarded {
                    forwardedIndicator
                }
                
                if let repliedMessage = message.forwardedMessage {
                    RepliedMessageCellView(message: repliedMessage)
                        .padding(2)
                        .onTapGesture {
                            onRepliedMessageTap(repliedMessage.uniqueId)
                        }
                }
                
                messageBody
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            HStack(spacing: 4) {
                if message.isStarred {
                    Image(systemName: "star.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.lightText)
                        .frame(width: 12, height: 12)
                }
                
                messageDetails
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
        }
        .background(message.isOutgoing ? .outgoingMessageBubble : .incomingMessageBubble)
        .cornerRadius(.messageBubbleCornerRadius, corners: [.topLeft, .topRight, message.isOutgoing ? .bottomLeft : .bottomRight])
        .shadow(color: .messageBubbleShadow, radius: 0, x: 2, y: 2)
    }
    
    @ViewBuilder
    private var forwardedIndicator: some View {
        HStack(spacing: 4) {
            Image(systemName: "arrowshape.turn.up.right")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.lightText)
                .frame(width: 14, height: 14)

            LocalizedText("forwarded")
                .font(.defaultText)
                .foregroundStyle(.lightText)
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private var messageBody: some View {
        switch message._type {
        case .text:
            TextMessageCellView(message: message as! TextMessage)
                .padding([.leading, .top, .trailing], 8)
                .padding(.bottom, 2)
        case .voice:
            VoiceMessageCellView(message: message as! VoiceMessage)
                .padding([.horizontal, .top], 6)
                .padding(.bottom, -14)
        case .photo:
            PhotoMessageCellView(message: message as! PhotoMessage)
                .padding(2)
        case .sharedPost:
            PostMessageCellView(message: message as! PostMessage)
                .allowsHitTesting(false)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var messageDetails: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            message.timestampView
                .alignmentGuide(.firstTextBaseline) { context in
                    context[.bottom] - 2
                }
            message.deliveryReceiptView
        }
    }
}

extension ChatMessage {
    enum MessageType: String {
        case text = "text"
        case voice = "audio"
        case photo = "photo"
        case sharedPost = "post"
        case unknown
    }
}

private extension ChatMessage {
    enum DeliveryStatus: String {
        case none
        case pending
        case sent
        case delivered
        case read
        case failed
    }
}

private extension ChatMessage {
    var _deliveryStatus: DeliveryStatus {
        if let deliveryStatus {
            return DeliveryStatus(rawValue: deliveryStatus) ?? .none
        }
      
        return .none
    }
}

extension ChatMessage {
    @ViewBuilder
    var deliveryReceiptView: some View {
        switch _deliveryStatus {
        case .pending:
            clock
                .foregroundStyle(.lightText)
        case .sent:
            singleCheckmark
                .foregroundStyle(.lightText)
        case .delivered:
            doubleCheckmark
                .foregroundStyle(.lightText)
        case .read:
            doubleCheckmark
                .foregroundStyle(.nfsGreen)
        case .failed:
            clock
                .foregroundStyle(.lightText)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var clock: some View {
        Text("\u{e902}")
            .font(.icomoon13)
    }
    
    @ViewBuilder
    private var singleCheckmark: some View {
        Text("\u{e903}")
            .font(.icomoon13)
    }
    
    @ViewBuilder
    private var doubleCheckmark: some View {
        HStack(spacing: -8) {
            singleCheckmark
            singleCheckmark
        }
    }
}

extension ChatMessage {
    var timestampView: some View {
        Text(timestampString)
            .font(.chatMessageDetails)
            .foregroundStyle(.lightText)
    }
}

extension ChatMessage {
    var _type: MessageType {
        if self.isKind(of: VoiceMessage.self){
            return .voice
        }
        
        if self.isKind(of: PhotoMessage.self){
            return .photo
        }
        
        if self.isKind(of: TextMessage.self){
            return .text
        }
        
        if self.isKind(of: PostMessage.self){
            return .sharedPost
        }
        
        return .unknown
    }

    var isTextMessage: Bool {
        _type == .text
    }

    var isPhotoMessage: Bool {
        _type == .photo
    }

    var isVoiceMessage: Bool {
        _type == .voice
    }

    var isPostMessage: Bool {
        _type == .sharedPost
    }
}

extension ChatMessage {
    open override var textRepresentation: String {
        switch self._type {
        case .text:
            return self.body ?? ""
        case .voice:
            return "🎤 " + "voice_message_body".localized
        case .photo:
            return "📷 " + "photo_message_body".localized
        case .sharedPost:
            return "✉️" + (isOutgoing ? "self_shared_post_message_body" : "others_shared_post_message_body").localized
        case .unknown:
            return ""
        }
    }
}

private struct ChatMessageCellRepliedMessageTapKey: EnvironmentKey {
    static let defaultValue: (String) -> Void = { _ in }
}

extension EnvironmentValues {
  var onReppliedMessageTap: (String) -> Void {
    get { self[ChatMessageCellRepliedMessageTapKey.self] }
    set { self[ChatMessageCellRepliedMessageTapKey.self] = newValue }
  }
}
