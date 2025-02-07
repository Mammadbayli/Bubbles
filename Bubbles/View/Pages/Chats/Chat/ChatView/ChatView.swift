//
//  ChatView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/28/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import CoreData
import IQKeyboardManager
import JMessageInput
import SwiftUI

struct ChatView: View {
    @SectionedFetchRequest<String, ChatMessage> private var messages: SectionedFetchResults<String, ChatMessage>
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .progressViewNavigationBar()
            .toolbar {
                toolbar
            }
            .confirmationDialog("", isPresented: $viewModel.attachmentOptionsPresented) {
                Button {
                    viewModel.showImagePickerWith(source: .photos)
                } label: {
                    LocalizedText("photo_source_photos")
                }
                
                Button {
                    viewModel.showImagePickerWith(source: .camera)
                } label: {
                    LocalizedText("photo_source_camera")
                }
            }
            .onAppear {
                viewModel.onAppear()
                IQKeyboardManager.shared().isEnabled = false
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
    
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            NavigationLink {
                UserProfileView(username: viewModel.chatId)
            } label: {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .renderingMode(.template)
                            .foregroundStyle(.nfsGreen)
                    }
                    SelfDownloadingAvatarView(username: viewModel.chatId)
                        .scaleEffect(0.8)
                        .padding(2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.navigationTitle)
                            .foregroundStyle(.nfsGreen)
                            .font(.navigationTitleSmall)
                        
                        if let status = viewModel.chatActivityStatus {
                            Text(status)
                                .foregroundStyle(.lightText)
                                .font(.navigationSubtitle)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack(spacing: .zero) {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    list
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .environment(\.onReppliedMessageTap, { id in
                            withAnimation {
                                proxy.scrollTo(id, anchor: .center)
                            }
                        })
                        .onAppear {
                            if let id = viewModel.selectedMessageId {
                                proxy.scrollTo(id, anchor: .center)
                            }
                        }
                }
                .rotationEffect(.radians(.pi))
                .scaleEffect(x: -1, y: 1, anchor: .center)
                .background(.defaultBackground)
                .onTapGesture {
                    self.endTextEditing()
                }
            }

            viewModel.compactMessageView

            JMessageInputView(durationString: viewModel.recordingDuration.string,
                              delegate: viewModel)
            .frame(height: 50)
        }
    }

    @ViewBuilder
    private var list: some View {
        LazyVStack(alignment: .center, spacing: 6, pinnedViews: [.sectionFooters]) {
            ForEach(messages) { section in
                Section(footer: SectionHeader(text: section.id)) {
                    ForEach(section) { message in
                        ChatMessageCellView(message: message) {
                            viewModel.contextMenu(for: message)
                        } onTap: {
                            viewModel.onTapGesture(message: message)
                        }
                        .id(message.uniqueId)
                        .onAppear {
                            viewModel.onMessageCellAppear(message: message)
                        }
                    }
                }
                .rotationEffect(.radians(.pi))
                .scaleEffect(x: -1, y: 1, anchor: .center)
            }
        }
    }
    
    init(viewModel: ChatViewModel) {
        _messages = SectionedFetchRequest(entity: ChatMessage.entity(),
                                          sectionIdentifier: \.sectionTitle,
                                          sortDescriptors: [
                                            NSSortDescriptor(key: "timestamp", ascending: false)
                                          ],
                                          predicate: NSPredicate(format: "chat.chatId == %@", viewModel.chatId),
                                          animation: .easeOut)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

private extension ChatView {
    struct SectionHeader: View {
        var text: String
        var body: some View {
            VStack {
                Spacer()
                    .frame(height: 4)
                Text(text)
                    .font(.defaultText)
                    .foregroundStyle(.white)
                    .padding(4)
                    .background(.nfsGreen)
                    .cornerRadius(8, corners: .allCorners)
                
                Spacer()
                    .frame(height: 4)
            }
        }
    }
}

struct JMessageInputView: UIViewRepresentable {
    let durationString: String
    let delegate: ChatViewModel
    
    init(durationString: String, delegate: ChatViewModel) {
        self.durationString = durationString
        self.delegate = delegate
    }
    
    func makeUIView(context: Context) -> JMessageInput {
        let input = JMessageInput()
        input.delegate = delegate
        input.translatesAutoresizingMaskIntoConstraints = true
        input.tintColor = .nfsGreen()
        input.backgroundColor = .lighterBackground()
        input.textView.inputAccessoryView = UIView()
        input.maxTextHeight = 40
        
        return input
    }
    
    func updateUIView(_ input: JMessageInput, context: Context) {
        input.recordingDurationLabel.text = durationString
    }
}
