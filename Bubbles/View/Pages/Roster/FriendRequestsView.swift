//
//  FriendRequestsView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/14/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct FriendRequestsView: View {
    @FetchRequest(
        sortDescriptors:[],
        animation: .smooth
    ) private var requests: FetchedResults<BuddyRequest>
    
    var body: some View {
        List(requests) { request in
            if let username = request.username {
                HStack {
                    SelfDownloadingAvatarView(username: username)
                    Text(username.uppercased())
                        .font(.rosterCellTitle)
                        .foregroundStyle(.defaultText)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button {
                            RosterController.sharedInstance().accept(request)
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "person.fill.checkmark")
                                    .renderingMode(.template)
                                LocalizedText("friend_requests_accept_request")
                                    .font(.rosterCellSubtitle)
                            }
                            .foregroundStyle(.nfsGreen)
                        }
                        .buttonStyle(.borderless)
                        
                        Button {
                            RosterController.sharedInstance().declineBuddyRequest(request)
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "person.fill.xmark")
                                    .renderingMode(.template)
                                LocalizedText("friend_requests_decline_request")
                                    .font(.rosterCellSubtitle)
                            }
                            .foregroundStyle(.red)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color(UIColor.systemBackground))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .overlay {
                    NavigationLink {
                        UserProfileView(username: username)
                    } label: {
                        EmptyView()
                    }
                    .isDetailLink(false)
                    .opacity(0)
                }
            }
        }
        .listStyle(.plain)
        .background(.defaultBackground)
        .nfsNavigationTitle(title: "friend_requests")
    }
}

extension BuddyRequest: Identifiable {
    public var id: String {
        self.username ?? ""
    }
}
