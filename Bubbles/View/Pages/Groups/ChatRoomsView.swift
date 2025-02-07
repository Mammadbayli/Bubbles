//
//  ChatRoomsView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 4/27/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import CoreData
import SwiftUI

struct ChatRoomsView: View {
    @FetchRequest(sortDescriptors:[])private var rooms: FetchedResults<ChatRoom>
    @State private var searchText: String = ""
    @ObservedObject var roomCategory: ChatRoomCategory
    @State private var showList = false
    @State private var navigate = false
    
    var body: some View {
        VStack {
            if showList {
                List(rooms) { room in
                    NavigationLink {
                        PostsView(room: room)
                    } label: {
                        BadgeCellView(imageURL: room.icon,
                                      text: room.name ?? "",
                                      badgeCount: Int(room.unreadCount))
                    }
                    .listRowBackground(Color(UIColor.systemBackground))
                }
                .searchable(text: $searchText, prompt: Text("search".localized))
                .listStyle(.plain)
                .background(.defaultBackground)
                .nfsNavigationTitle(title: roomCategory.name ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: searchText) { value in
                    rooms.nsPredicate = value.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", value)
                }
            }
        }
        .onAppear {
            showList = true
        }
    }
    
    init(category: ChatRoomCategory) {
        let predicate = NSPredicate(format: "category.categoryId == %@", category.categoryId ?? "")
        _rooms = FetchRequest(entity: ChatRoom.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: predicate)
        self.roomCategory = category
    }
}

extension ChatRoom: Identifiable {}

