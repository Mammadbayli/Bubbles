//
//  CommentCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct CommentCellView: View {
    private let comment: Comment
    @State private var photo: UIImage?
    
    var body: some View {
        HStack(alignment: .top) {
            SelfDownloadingAvatarView(username: comment.from ?? "")
           
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.from?.uppercased() ?? "")
                        .font(.commentCellTitle)
                        .foregroundStyle(.defaultText)
                    
                    Spacer()
                    
                    Text(comment.timestampString)
                        .font(.commentCellTimestamp)
                        .foregroundStyle(.lightText)
                }
                
                Text(comment.body ?? "")
                    .font(.commentCellBody)
                    .foregroundStyle(.defaultText)
            }
            .padding(6)
            .background(.white)
            .cornerRadius(.messageBubbleCornerRadius, corners: [.topRight, .bottomRight, .bottomLeft])
        }
    }
    
    init(comment: Comment) {
        self.comment = comment
    }
}
