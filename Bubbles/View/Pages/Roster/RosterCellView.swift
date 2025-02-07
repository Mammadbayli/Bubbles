//
//  RosterCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/5/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct RosterCellView: View {
    @ObservedObject private var buddy: Buddy
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(alignment: .center) {
                SelfDownloadingAvatarView(username: buddy.username)
                
                VStack(alignment: .leading) {
                    Text(buddy.username.uppercased())
                        .font(.rosterCellTitle)
                        .foregroundStyle(.defaultText)
                    
                    HStack {
                        Text(buddy.name ?? "")
                            .font(.rosterCellSubtitle)
                            .foregroundStyle(.lightText)
                        
                        Text(buddy.surname ?? "")
                            .font(.rosterCellSubtitle)
                            .foregroundStyle(.lightText)
                    }
                }
                
                Spacer()
                
                if !buddy.isInRoster {
                    Image(systemName: "person.badge.clock")
                        .renderingMode(.template)
                        .foregroundStyle(.red)
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 30)
            .padding(.vertical, 8)
        }
        .background(.white)
        .opacity(buddy.isInRoster ? 1 : 0.3)
    }
    
    init(buddy: Buddy) {
        self.buddy = buddy
    }
}
