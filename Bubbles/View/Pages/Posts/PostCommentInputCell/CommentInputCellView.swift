//
//  CommentInputCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct CommentInputCellView: View {
    var onSubmit: ((String) -> Void)?
    
    @State private var commentBody: String = ""
    @State private var localizedLabel = "write_a_comment".localized
    private let languagePublisher = NotificationCenter.default.publisher(for: .init("language-did-change"))
    
    var body: some View {
        HStack {
            SelfDownloadingAvatarView(username: PersistencyManager.sharedInstance().getUsername())

            JTextField(
                localizedLabel,
                text: $commentBody
            )
            
            NFSButton(label: "send", style: .green(), action: {
                onSubmit?(commentBody)
                commentBody = ""
            })
        }
        .onReceive(languagePublisher) { _ in
            localizedLabel = "write_a_comment".localized
        }
    }
    
    init(onSubmit: ((String) -> Void)? = nil) {
        self.onSubmit = onSubmit
    }
}
