//
//  PostActionView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct PostActionView: View {
    private var icon: String
    private var label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(icon)
                .foregroundStyle(.nfsGreen)
                .font(.icomoon16)
            
            LocalizedText(label)
                .foregroundStyle(.lightText)
                .font(.defaultText)
                .lineLimit(1)
        }
    }
    
    init(icon: String, label: String) {
        self.icon = icon
        self.label = label
    }
}
