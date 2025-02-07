//
//  LocalizedText.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/8/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct LocalizedText: View {
    var text: String
    
    private let languagePublisher = NotificationCenter.default.publisher(for: .init("language-did-change"))
    @State private var localizedText: String
    
    var body: some View {
        Text(localizedText)
            .onReceive(languagePublisher) { _ in
                localizedText = text.localized
            }
    }
    
    init(_ text: String) {
        self.text = text
        _localizedText = State(initialValue: text.localized)
    }
}
