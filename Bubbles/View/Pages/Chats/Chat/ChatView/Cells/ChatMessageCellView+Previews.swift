//
//  ChatMessageCellView+Previews.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/6/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

#Preview {
    let body = """
    Before we continue to add previews of multiple
    different states of our SwiftUI button, we need to be able to display multiple previews.
    """
    var textMessage: TextMessage {
        let entity = NSManagedObjectModel.mergedModel(from: nil)?.entitiesByName["TextMessage"]
        let msg = TextMessage(entity: entity!, insertInto: nil)
        msg.body = "Before we continue to add previews of multiple different states of our SwiftUI button, we need to be able to display multiple previews."
        msg.from = "12-aa-001"
        msg.isStarred = true
        msg.timestamp = Date()
        msg.deliveryStatus = "read"
        msg.isForwarded = true
        msg.forwardedMessage = msg
        msg.to = "12-aa-001"

        return msg
    }

    var photoMessage: PhotoMessage {
        let entity = NSManagedObjectModel.mergedModel(from: nil)?.entitiesByName["PhotoMessage"]
        let msg = PhotoMessage(entity: entity!, insertInto: nil)
        msg.body = body
        msg.from = "12-aa-001"
        msg.isStarred = true
        msg.timestamp = Date()
        msg.deliveryStatus = "read"
        msg.isForwarded = true
        msg.forwardedMessage = msg
        msg.to = "12-aa-001"
        let file = file(with: "Sbnc2tYD6I43FYj5")
        file.type = "photo"
        msg.addFilesObject(file)

        return msg
    }

    var voiceMessage: VoiceMessage {
        let entity = NSManagedObjectModel.mergedModel(from: nil)?.entitiesByName["VoiceMessage"]
        let msg = VoiceMessage(entity: entity!, insertInto: nil)
        msg.body = body
        msg.from = "12-aa-001"
        msg.isStarred = true
        msg.timestamp = Date()
        msg.deliveryStatus = "read"
        msg.isForwarded = true
        msg.forwardedMessage = msg
        msg.to = "12-aa-001"
        let file = file(with: "Jdw5E95MlBs0zHyF")
        file.type = "photo"
        msg.addFilesObject(file)

        return msg
    }

    func file(with id: String) -> File {
        let entity = NSManagedObjectModel.mergedModel(from: nil)?.entitiesByName["File"]
        let file = File(entity: entity!, insertInto: nil)
        file.name = id

        return file
    }

    return VStack {
        Spacer()
        
        Group {
            ChatMessageCellView(message: textMessage)
            ChatMessageCellView(message: photoMessage)
            ChatMessageCellView(message: voiceMessage)
        }
        .padding(.horizontal)

        Spacer()
    }
    .background(.gray)
}
