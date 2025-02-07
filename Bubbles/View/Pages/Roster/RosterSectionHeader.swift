//
//  RosterSectionHeader.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/14/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct RosterSectionHeader: View {
    private var text: String
    var body: some View {
        HStack {
            Text(text)
                .foregroundStyle(.nfsGreen)
                .multilineTextAlignment(.leading)
                .padding(.leading, 10)
            Spacer()
        }
    }
    
    init(text: String) {
        self.text = text
    }
}
