//
//  BuddyPickerView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/22/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI
import CoreData

struct BuddyPickerView: View {
    var allowsMultipleSelection: Bool = false
    var onSelectBuddies: ((Set<String>) -> Void)?

    @SectionedFetchRequest<String, Buddy>(
        sectionIdentifier: \.sectionTitle!,
        sortDescriptors: [
            NSSortDescriptor(key: "sectionTitle", ascending: true),
            NSSortDescriptor(key: "username", ascending: true)
        ],
        animation: .default)
    private var sections: SectionedFetchResults<String, Buddy>

    @State private var searchText: String = ""
    @State private var selectedUserames = Set<String>()

    var body: some View {
        list
            .nfsNavigationTitle(title: "friends")
            .toolbar {
                if allowsMultipleSelection {
                    Button {
                        onSelectBuddies?(selectedUserames)
                    } label: {
                        LocalizedText("send")
                            .font(.nfs(size: 18))
                            .foregroundStyle(.nfsGreen)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("search".localized))
            .background(.defaultBackground)
            .onChange(of: searchText) { value in
                sections.nsPredicate = value.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "(username CONTAINS[cd] %@) OR (ANY attributes.value CONTAINS[cd] %@)", value, value)
            }
            .navigationBarTitleDisplayMode(.inline)
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
            .onTapGesture {
                self.endTextEditing()
            }
    }

    @ViewBuilder
    private var list: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(sections.indices, id: \.self) { index in
                    Section(header: RosterSectionHeader(text: sections[index].id)) {
                        ForEach(sections[index]) { buddy in
                            cell(buddy: buddy)
                        }
                    }
                }
            }
        }
        .background(.defaultBackground)
    }

    @ViewBuilder
    private func cell(buddy: Buddy) -> some View {
        HStack(spacing: .zero) {
            RosterCellView(buddy: buddy)
            Spacer()
            if buddy.isInRoster && allowsMultipleSelection {
                checkMark(filled: selectedUserames.contains(buddy.username))
                    .padding(.horizontal)
            }
        }
        .background(.lighterBackground)
//        .listRowInsets(EdgeInsets())
        .allowsHitTesting(buddy.isInRoster)
        .onTapGesture {
            if selectedUserames.contains(buddy.username) {
                selectedUserames.remove(buddy.username)
            } else {
                selectedUserames.insert(buddy.username)
            }

            if !allowsMultipleSelection {
                onSelectBuddies?(selectedUserames)
            }
        }
    }

    @ViewBuilder
    private func checkMark(filled: Bool) -> some View {
        filled ?
        Image(systemName: "checkmark.circle.fill")
            .renderingMode(.template)
            .foregroundStyle(.nfsGreen)
        :
        Image(systemName: "checkmark.circle")
            .renderingMode(.template)
            .foregroundStyle(.nfsGreen)
    }

    init(allowsMultipleSelection: Bool,
         onSelectBuddies: ((Set<String>) -> Void)? = nil) {
        self.allowsMultipleSelection = allowsMultipleSelection
        self.onSelectBuddies = onSelectBuddies

        RosterController.sharedInstance().fetchRoster()
    }
}

@objc class BuddyPickerViewContainer: NSObject {
    @objc static func create(allowsMultipleSelection: Bool, onSelectBuddies: ((Set<String>) -> Void)? = nil) -> UIViewController {
        let view = BuddyPickerView(allowsMultipleSelection: allowsMultipleSelection, onSelectBuddies: onSelectBuddies)
            .environment(
                \.managedObjectContext,
                 CoreDataStack.sharedInstance().mainContext)

        let hostingController = HostingViewController(rootView: view)
        return hostingController
    }
}

