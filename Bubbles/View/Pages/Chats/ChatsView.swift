//
//  ChatsView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/10/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import CoreData
import SwiftUI

struct ChatsView: View {
    @FetchRequest(sortDescriptors:[NSSortDescriptor(keyPath: \Chat.latestMessage?.timestamp, ascending: false)], animation: .smooth) 
    private var chats: FetchedResults<Chat>
    @FetchRequest(sortDescriptors:[.orderedDescendingByTimestamp], predicate: NSPredicate(value: false), animation: .smooth) 
    private var filteredMessages: FetchedResults<ChatMessage>
    @State private var searchText: String = ""
    @State private var newChatId: String?
    @State private var navigate = false
    
    var body: some View {
        NavigationView {
            VStack {
                hiddenNavigator
                
                if searchText.isEmpty {
                    chatsList
                } else {
                    filteredMessagesList
                }
            }
            .nfsNavigationTitle(title: "chats")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: Text("search".localized))
            .toolbar {
                Button {
                    BuddySelector.sharedInstance().select(withMultipleOption: false).pipe { result in
                        switch result {
                        case .fulfilled(let buddies):
                            if let buddies = buddies as? Set<String> {
                                newChatId = buddies.first
                                navigate.toggle()
                            }
                        case .rejected(let error):
                            print(error)
                        }
                    }
                } label: {
                    Text("\u{ea05}")
                        .font(.nfs(size: 23))
                        .foregroundStyle(.nfsGreen)
                }
            }
            .onChange(of: searchText) { value in
                if value.isEmpty {
                    filteredMessages.nsPredicate = NSPredicate(value: false)
                } else {
                    filteredMessages.nsPredicate = NSPredicate(format: "(body CONTAINS[cd] %@) OR (from CONTAINS[cd] %@) OR (to CONTAINS[cd] %@)", value, value, value)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .navigateToChat)) { value in
                if let chatId = value.userInfo?["chatId"] as? String {
                    newChatId = chatId
                    navigate.toggle()
                }
            }
        }
        .tint(.nfsGreen)
        .badge(chats.reduce(0, { result, element in
            result + Int(element.unreadCount)
        }))
    }
    
    @ViewBuilder
    private var hiddenNavigator: some View {
        NavigationLink(destination: ChatView(viewModel: ChatViewModel(chatId: newChatId ?? "")),
                       isActive: $navigate) {
            EmptyView()
        }.hidden()
    }
    
    @ViewBuilder
    private var chatsList: some View {
        List(chats) { chat in
            cell(with: chat)
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private var filteredMessagesList: some View {
        List(filteredMessages) { message in
            NavigationLink {
                if let chatId = message.chatId {
                    ChatView(viewModel: ChatViewModel(chatId: chatId, selectedMessageId: message.uniqueId))
                } else {
                    Text("Error")
                }
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        LocalizedText(message.senderTitle)
                            .font(.chatCellTitle)
                            .foregroundStyle(.defaultText)
                        
                        Text(message.textRepresentation)
                            .font(.chatCellSubtitle)
                            .foregroundStyle(.lightText)
                    }
                    
                    Spacer()
                    
                    Text(message.timestampString)
                        .font(.chatCellSubtitle)
                        .foregroundStyle(.lightText)
                }
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
        .overlay {
            if filteredMessages.isEmpty {
                LocalizedText("search_no_results")
                    .multilineTextAlignment(.center)
                    .font(.defaultText)
                    .foregroundStyle(.defaultText)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private func cell(with chat: Chat) -> some View {
        ChatCellView(chat: chat)
            .overlay {
                NavigationLink {
                    if let chatId = chat.chatId {
                        ChatView(viewModel: ChatViewModel(chatId: chatId))
                    } else {
                        Text("Error")
                    }
                } label: {
                    EmptyView()
                }
                .isDetailLink(false)
                .opacity(0)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button {
                    if let context = chat.managedObjectContext {
                        Chat.deleteChat(withChatId: chat.chatId, using: context)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .tint(.red)
                }
            }
    }
}

extension Chat: Identifiable {
    public var id: String? {
        self.chatId
    }
}

extension Chat {
    override public func willSave() {
        if  !isDeleted,
            let newMessage = messages?.lastObject as? ChatMessage,
            (latestMessage == nil || !newMessage.isEqual(latestMessage)) {
            latestMessage = messages?.lastObject as? ChatMessage
        }
        
        super.willSave()
    }
}
