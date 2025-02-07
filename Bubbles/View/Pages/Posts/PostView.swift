//
//  PostView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import CoreData
import SwiftUI
import IQKeyboardManager

extension NSSortDescriptor {
    static let orderedAscendingByTimestamp = NSSortDescriptor(key: "timestamp", ascending: true)
    static let orderedDescendingByTimestamp = NSSortDescriptor(key: "timestamp", ascending: false)
}

struct PostView: View {
    @FetchRequest(sortDescriptors:[]) private var posts: FetchedResults<Post>
    
    var body: some View {
        scrollView
    }
    
    @ViewBuilder
    private var scrollView: some View {
        if let post = posts.first {
            ScrollView(.vertical) {
                LazyVStack(spacing: 8) {
                    PostCellView(post: post)
                        .onAppear {
                            post.setRead()
                        }
                    
                    ForEach((post.comments.array as? [Comment]) ?? []) { comment in
                        CommentCellView(comment: comment)
                            .onAppear {
                                comment.markAsRead()
                                LocalNotificationsController.sharedInstance().removeNotification(withIdentifier: comment.uniqueId)
                            }
                    }
                    
                    CommentInputCellView { commentBody in
                        sendComment(commentBody: commentBody)
                    }
                    .background(.defaultBackground)
                }
                .padding([.leading, .trailing, .bottom], 8)
            }
            .background(.defaultBackground)
            .nfsNavigationTitle(title: post.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                (UIApplication.shared.delegate as? AppDelegate)?.currentPost = post.notificationTitle
                IQKeyboardManager.shared().isEnabled = false
            }
            .onDisappear {
                (UIApplication.shared.delegate as? AppDelegate)?.currentPost = nil
                IQKeyboardManager.shared().isEnabled = true
            }
            .onTapGesture {
                self.endTextEditing()
            }
        }
    }
    
    init(postId: String) {
        let predicate = NSPredicate(format: "uniqueId == %@", postId)
        _posts = FetchRequest(entity: Post.entity(), sortDescriptors: [.orderedDescendingByTimestamp], predicate: predicate)
    }
    
    private func sendComment(commentBody: String) {
        guard !commentBody.isEmpty else { return }
        
        if let context = posts.first?.managedObjectContext {
            context.perform {
                let comment = Comment(context: context)
                comment.body = commentBody
                comment.post = posts.first
                comment.isUnread = false
                comment.send()
            }
        }
    }
}
