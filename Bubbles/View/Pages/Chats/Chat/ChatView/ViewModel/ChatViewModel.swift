//
//  ChatViewModel.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/29/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import CoreData
import SwiftUI

class ChatViewModel: NSObject, ObservableObject {
    @Published var recordingDuration: TimeInterval = 0
    @Published var attachmentOptionsPresented = false
    @Published var chatActivityStatus: String?
    @Published var chatAvatarKey: String = ""
    @Published var messageIdBeingRepliedTo: NSManagedObjectID?
    @Published var latestMessageId: String?
    @Published var offsetForKeyboard: CGFloat = 0
    var keyboardAnimationDuration: TimeInterval = 0
    
    let chatId: String
    let selectedMessageId: String?
    let mediaPicker: MediaPickerController
    let recorder: AVController
    let hapticGenerator: UIImpactFeedbackGenerator
    
    var navigationTitle: String {
        chatId.uppercased()
    }
    
    init(chatId: String,
         selectedMessageId: String? = nil,
         recorder: AVController = AVController.sharedInstance(),
         mediaPicker: MediaPickerController = MediaPickerController(),
         hapticGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()) {
        self.chatId = chatId
        self.selectedMessageId = selectedMessageId
        self.recorder = recorder
        self.mediaPicker = mediaPicker
        self.hapticGenerator = hapticGenerator
        chatAvatarKey = UserPhoto(forUsername: chatId, using: CoreDataStack.sharedInstance().mainContext).name ?? ""
        
        super.init()
        
        registerLastActivityObersvers()
        registerCoreDataObserver()
    }
}

extension ChatViewModel {
    var compactMessageView: CompactMessageView? {
        guard  let objectId = messageIdBeingRepliedTo ,
               let message = try? CoreDataStack.sharedInstance().mainContext.existingObject(with: objectId) as? ChatMessage else { return nil }
        
        return CompactMessageView(message: message) {
            withAnimation {
                self.messageIdBeingRepliedTo = nil
            }
        }
    }
}

extension ChatViewModel {
    func onTapGesture(message: ChatMessage) {
        switch message._type {
        case .text, .unknown:
            break
        case .photo:
            viewPhotosFor(message: message)
        case .voice:
            break
        case .sharedPost:
            navigateToPostView(post: message.post)
        }
    }
}

extension ChatViewModel {
    func navigateToPostView(post: Post?) {
        if let post {
            (UIApplication.shared.delegate as? AppDelegate)?.navigateToPost(withId: post.uniqueId)
        }
    }
}
