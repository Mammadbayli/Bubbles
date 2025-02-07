//
//  BadgeCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 4/27/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import CachedAsyncImage
import SwiftUI

struct BadgeCellView: View {
    var imageURL: URL?
    var text: String
    var badgeCount: Int
    
    var body: some View {
        HStack {
            CachedAsyncImage(
                url: imageURL,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .fixedSize()
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(height: 48)
            
            Text(text)
                .font(.tableCellText)
            
            Spacer()
            
            if badgeCount > 0 {
                BadgeView(label: String(badgeCount))
            }
        }
        .background(.lighterBackground)
    }
}
