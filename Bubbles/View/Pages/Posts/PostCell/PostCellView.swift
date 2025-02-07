//
//  PostCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import Combine
import SwiftUI
import PromiseKit

struct PostCellView: View {
    @ObservedObject private var post: Post
    @State private var isStarred: Bool = false
    private var handleImageTap = true
    
    private var imageName: String? {
        (post.files?.firstObject as? File)?.name
    }
    
    @ViewBuilder
    private var views: some View {
        VStack(alignment: .leading) {
            Text(post.title ?? "")
                .font(.postCellTitle)
            
            HStack(spacing: 4) {
                Text(post.from ?? "")
                    .textCase(.uppercase)
                Text(post.timestampString)
            }
            .font(.postCellSuibtitle)
            .foregroundStyle(.lightText)
            
            Text(post.body ?? "")
                .font(.postCellBody)
            
            if let imageName {
                SelfDownloadingImageView(name: imageName,
                                         thumbnailSize: CGSize(width: 600, height: 300))
                    .scaledToFill()
                    .frame(maxHeight: 200)
                    .cornerRadius(.messageBubbleCornerRadius)
                    .contentShape(Rectangle())
                    .allowsHitTesting(handleImageTap)
                    .onTapGesture {
                        viewPhotos()
                    }
            }
            
            actions
        }
    }
    
    @ViewBuilder
    private var actions: some View {
        HStack {
            Group {
                PostActionView(icon: "\u{e904}", label: String.init(format: "post_comments".localized, post.comments.count))
                    .nfsBadge(count: post.badgeCount)
                    .id(UUID())
                
//                PostActionView(icon: isStarred ? "\u{e9d9}" : "\u{e9d7}", label: "save")
//                    .onTapGesture {
//                        isStarred.toggle()
//                    }
                
                PostActionView(icon: "\u{e901}", label: "post_share")
                    .onTapGesture {
                        share()
                    }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    var body: some View {
        VStack {
            views
                .padding(10)
        }
        .background(.lighterBackground)
        .cornerRadius(10)
        .onChange(of: isStarred) { newValue in
            post.setStarred(newValue)
        }
    }
    
    init(post: Post, handleImageTap: Bool = true) {
        self.post = post
        self.handleImageTap = handleImageTap
        _isStarred = State(initialValue: post.isStarred)
    }
    
    private func share() {
        BuddySelector.sharedInstance().select(withMultipleOption: true).pipe { result in
            switch result {
            case .fulfilled(let buddies):
                if let buddies = buddies as? Set<String> {
                    sharePostTo(buddies: buddies)
                }
            case .rejected(let error):
                print(error)
            }
        }
    }
    
    private func sharePostTo(buddies: Set<String>) {
        for buddy in buddies {
            post.share(withUser: buddy)
        }
    }
    
    private func viewPhotos() {
        let photoNames = post.files?.compactMap { ($0 as? File)?.name } ?? []
        
        let viewer = PhotoViewerController()
        
        viewer.viewPhotos(photoNames)
        viewer.titleForIndex = {(index: UInt)-> String in
            post.title ?? ""
        }
        
        viewer.subtitleForIndex = {(index: UInt)-> String in
            post.timestampString
        }
    }
}

extension Post {
    var badgeCount: Int? {
        let count = Int(unreadCount - (isUnread ? 1 : 0))
        return count > 0 ? count : nil
    }
}
