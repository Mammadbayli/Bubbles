//
//  RosterView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/5/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI
import CoreData

struct RosterView: View {
    @SectionedFetchRequest<String, Buddy>(
        sectionIdentifier: \.sectionTitle!,
        sortDescriptors: [
            NSSortDescriptor(key: "sectionTitle", ascending: true),
            NSSortDescriptor(key: "username", ascending: true)
        ],
        animation: .default)
    private var sections: SectionedFetchResults<String, Buddy>
    
    @FetchRequest(sortDescriptors: [], animation: .default) private var buddyRequests: FetchedResults<BuddyRequest>
    @State private var sheet: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            list
                .nfsNavigationTitle(title: "friends")
                .toolbar {
                    Button {
                        sheet.toggle()
                    } label: {
                        Text("\u{ea0a}")
                            .font(.nfs(size: 23))
                            .foregroundStyle(.nfsGreen)
                            .scaleEffect(CGSize(width: 1.3, height: 1.3))
                            .padding()
                    }
                }
                .sheet(isPresented: $sheet) {
                    AddFriendView()
                }
                .onAppear {
                    RosterController.sharedInstance().fetchRoster()
                }
                .overlay {
                    if sections.isEmpty {
                        LocalizedText(
                            searchText.isEmpty ? "roster.empty_list" : "search_no_results"
                        )
                        .multilineTextAlignment(.center)
                        .font(.defaultText)
                        .foregroundStyle(.defaultText)
                    }
                }
        }
        .tint(.nfsGreen)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("search".localized))
        .background(.defaultBackground)
        .onChange(of: searchText) { value in
            sections.nsPredicate = value.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "(username CONTAINS[cd] %@) OR (ANY attributes.value CONTAINS[cd] %@)", value, value)
        }
        .navigationBarTitleDisplayMode(.large)
        .badge(buddyRequests.count)
    }
    
    @ViewBuilder
    private var list: some View {
        List {
            if !buddyRequests.isEmpty && searchText.isEmpty {
                NavigationLink {
                    FriendRequestsView()
                        .nfsNavigationTitle(title: "friend_requests")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    HStack(spacing: .zero) {
                        BadgeView(label: String(buddyRequests.count))
                            .font(.defaultText)
                            .frame(width: 30, height: 30)
                            .fixedSize()
                        
                        LocalizedText("friend_requests")
                            .font(.tableCellText)
                            .foregroundStyle(.defaultText)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, idealHeight: 50)
                    .padding(.leading, 10)
                }
            }
            
            ForEach(sections.indices, id: \.self) { index in
                Section(header: RosterSectionHeader(text: sections[index].id)) {
                    ForEach(sections[index]) { buddy in
                        RosterCellView(buddy: buddy)
                            .overlay {
                                if buddy.isInRoster {
                                    NavigationLink {
                                        UserProfileView(username: buddy.username)
                                    } label: {
                                        EmptyView()
                                    }
                                    .isDetailLink(false)
                                    .opacity(0)
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    RosterController.sharedInstance().deleteRosterItem(buddy.username)
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .tint(.red)
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color(UIColor.systemBackground))
                    }
                }
            }
        }
        .listStyle(.plain)
        .background(.defaultBackground)
    }
    
    init() {
        RosterController.sharedInstance().fetchRoster()
    }
}

extension Buddy: Identifiable {}
