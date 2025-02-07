//
//  BadgeView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/8/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct BadgeView: View {
    var label: String
    var body: some View {
        Text(label)
            .font(.defaultText)
            .foregroundStyle(.white)
            .padding(.horizontal, 4)
            .padding(.top, 2)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.red)
            }
    }
}
