//
//  VoiceMessageCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/29/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import AVFoundation
import SwiftUI

struct VoiceMessageCellView: View {
    var message: ChatMessage
    @ObservedObject private var viewModel: VoiceMessageCellModel
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Button {
                    viewModel.play()
                } label: {
                    Text(viewModel.isPlaying ? "\u{ea1c}" : "\u{ea1d}")
                        .font(.nfs(size: 32))
                        .foregroundStyle(.nfsGreen)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ProgressView(value: viewModel.progress, total: 1)
                        .frame(width: 200)
                        .tint(.nfsGreen)
                    
                    Text(viewModel.remainingDurationString)
                        .font(.chatMessageDetails)
                        .foregroundStyle(.defaultText)
                }
                .alignmentGuide(.firstTextBaseline) { context in
                    context[.bottom] - 10
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("messageTapped"))) { notif in // Workaround for Menu primary action overriding any other gestures
            if let messageId = notif.userInfo?["messageId"] as? String,
               messageId == message.uniqueId {
                viewModel.play()
            }
        }
    }
    
    init(message: VoiceMessage, viewModel: VoiceMessageCellModel? = nil) {
        self.message = message
        self.viewModel = viewModel ?? VoiceMessageCellModel(message: message)
    }
}
