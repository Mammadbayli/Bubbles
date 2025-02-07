//
//  PostMessageCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/13/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct PostMessageCellView: View {
    var message: PostMessage
    
    var body: some View {
        PostCellView(post: message.post!, handleImageTap: false)
    }
}

