//
//  SavedMessagesView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/15/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct SavedMessagesView: View {
    @FetchRequest(sortDescriptors:[.orderedAscendingByTimestamp],
                  predicate: NSPredicate(format: "isStarred == 1"),
                  animation: .smooth)
    private var messages: FetchedResults<Message>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(messages) { message in
                    VStack(alignment:.leading) {
                        if let post = message as? Post {
                            PostCellView(post: post)
                        } else {
                            HStack {
                                if let username = message.from {
                                    SelfDownloadingAvatarView(username: username)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(message.from?.uppercased() ?? "")
                                        .font(.chatCellTitle)
                                        .foregroundStyle(.defaultText)
                                    
                                    Text(message.timestamp.formatted(date: .numeric, time: .shortened))
                                        .font(.navigationSubtitle)
                                        .foregroundStyle(.lightText)
                                }
                            }
                            
                            if let message = message as? ChatMessage {
                                ChatMessageCellView(message: message)
                            }
                        }
                        
                        Divider()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing, .bottom], 8)
        }
        .background(.defaultBackground)
        .nfsNavigationTitle(title: "settings_saved_messages")
        .overlay {
            if messages.isEmpty {
                LocalizedText("saved_messages.empty_list")
                    .multilineTextAlignment(.center)
                    .font(.defaultText)
                    .foregroundStyle(.defaultText)
                    .padding()
            }
        }
    }
}

extension Message: Identifiable {
    public var id: Int {
        (uniqueId + (isStarred ? "starred" : "notStarred")).hashValue
    }
}

@objc class SavedMessagesViewContainer: NSObject {
    @objc static func create() -> UIViewController {
        let postsView = SavedMessagesView()
            .environment(
                \.managedObjectContext,
                 CoreDataStack.sharedInstance().mainContext)
        let hostingController = HostingViewController(rootView: postsView)
        return hostingController
    }
}
