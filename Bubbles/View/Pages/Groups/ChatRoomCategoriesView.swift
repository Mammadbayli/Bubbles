//
//  ChatRoomCategoriesView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 4/27/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import CoreData
import SwiftUI

struct ChatRoomCategoriesView: View {
    @FetchRequest(sortDescriptors:[NSSortDescriptor(key: "name", ascending: true)])
    private var categories: FetchedResults<ChatRoomCategory>
    @State private var searchText: String = ""
    @State private var navigate = false
    @State private var postId = ""
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination:PostView(postId: postId),
                               isActive: $navigate) {
                    EmptyView()
                }.hidden()
                
                list
            }
        }
        .navigationViewStyle(.stack)
        .tint(.nfsGreen)
        .badge(categories.reduce(0, { result, element in
            result + Int(element.unreadCount)
        }))
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(NAVIGATE_TO_POST))) { value in
            if let postId = value.userInfo?["postId"] as? String {
                self.postId = postId
            }
            
            if !navigate {
                navigate = true
            }
        }
        .onAppear {
            GroupsController.sharedInstance().loadGroups()
        }
    }
    
    @ViewBuilder
    private var list: some View {
        List(categories) { category in
            NavigationLink {
                ChatRoomsView(category: category)
            } label: {
                BadgeCellView(imageURL: category.icon,
                              text: category.name ?? "",
                              badgeCount: Int(category.unreadCount))
            }
            .listRowBackground(Color(UIColor.systemBackground))
        }
        .searchable(text: $searchText, prompt: Text("search".localized))
        .listStyle(.plain)
        .background(.defaultBackground)
        .nfsNavigationTitle(title: "global_groups")
        .onChange(of: searchText) { value in
            categories.nsPredicate = value.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", value)
        }
    }
}

extension ChatRoomCategory: Identifiable {}


