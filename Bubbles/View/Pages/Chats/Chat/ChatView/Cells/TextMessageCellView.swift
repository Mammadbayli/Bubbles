//
//  TextMessageCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/29/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct TextMessageCellView: View {
    var message: TextMessage
    
    var body: some View {
        if let body = message.body {
            Text(body)
                .multilineTextAlignment(.leading)
                .font(.defaultText)
        }
    }
}
