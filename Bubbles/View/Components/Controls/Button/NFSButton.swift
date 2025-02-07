//
//  NFSButton.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/1/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

extension NFSButton {
    enum Style {
        case green(internalPadding: CGFloat = 8, fullWidth: Bool = false)
    }
}

struct NFSButton: View {
    private var label: String
    private var style: Style
    private var action: (() -> Void)?
    
    var body: some View {
        content
    }
    
    @ViewBuilder 
    private var content: some View {
        switch style {
        case .green(let internalPadding, let fullWidth):
            greenButton(padding: internalPadding, fullWidth: fullWidth)
        }
    }
    
    @ViewBuilder
    private func greenButton(padding: CGFloat, fullWidth: Bool) -> some View {
        Button {
            action?()
        } label: {
            LocalizedText(label)
                .font(.defaultText)
                .foregroundStyle(.white)
                .padding(padding)
                .frame(maxWidth: fullWidth ? .infinity : nil)
        }
        .background(.greenButton)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 1, x: 2, y: 2)
    }
    
    init(label: String, style: Style, action: (() -> Void)? = nil) {
        self.label = label
        self.action = action
        self.style = style
    }
}
