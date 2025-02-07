//
//  PostsView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/1/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import CoreData
import SwiftUI

struct PostsView: View {
    @ObservedObject private var room: ChatRoom
    @FetchRequest(sortDescriptors:[]) private var posts: FetchedResults<Post>
    @State private var searchText: String = ""
    @State private var sheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(posts) { post in
                    NavigationLink {
                        PostView(postId: post.uniqueId)
                    } label: {
                        PostCellView(post: post, handleImageTap: false)
                            .id(post.id)
                            .onAppear {
                                post.setRead()
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing, .bottom], 8)
        }
        .background(.defaultBackground)
        .nfsNavigationTitle(title: room.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: Text("search".localized))
        .onChange(of: searchText) { value in
            posts.nsPredicate = value.isEmpty ? NSPredicate(format: "room.roomId== %@", room.roomId): NSPredicate(format: "room.roomId== %@ AND ((title CONTAINS[cd] %@) OR (body CONTAINS[cd] %@)) ", room.roomId, value, value)
        }
        .toolbar {
            Button {
                sheet.toggle()
            } label: {
                Text("\u{ea05}")
                    .font(.nfs(size: 23))
                    .foregroundStyle(.nfsGreen)
            }
        }
        .sheet(isPresented: $sheet) {
            NewPost(roomId: room.roomId)
        }
        .overlay {
            if posts.isEmpty {
                LocalizedText(
                    searchText.isEmpty ? "posts.empty_list" : "search_no_results"
                )
                .multilineTextAlignment(.center)
                .font(.defaultText)
                .foregroundStyle(.defaultText)
                .padding()
            }
        }
    }
    
    init(room: ChatRoom) {
        self.room = room
        let predicate = NSPredicate(format: "room.roomId== %@", room.roomId)
        _posts = FetchRequest(entity: Post.entity(), sortDescriptors: [.orderedDescendingByTimestamp], predicate: predicate)
    }
}

struct NewPost: UIViewControllerRepresentable {
    typealias UIViewControllerType = NavigationController
    var roomId: String
    
    func makeUIViewController(context: Context) -> NavigationController {
        let newPostVC = CreatePostViewController(forGroupId: roomId)
        return NavigationController(rootViewController: newPostVC)
    }
    
    func updateUIViewController(_ uiViewController: NavigationController, context: Context) {
        
    }
}
