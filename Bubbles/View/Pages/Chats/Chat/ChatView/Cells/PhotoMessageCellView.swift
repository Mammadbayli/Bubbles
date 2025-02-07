//
//  PhotoMessageCellView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/29/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct PhotoMessageCellView: View {
    var message: PhotoMessage
    
    var body: some View {
        VStack(alignment: .leading) {
            image
            if let body = message.body {
                Text(body)
                    .multilineTextAlignment(.leading)
                    .font(.defaultText)
                    .padding(2)
            }
        }
    }
    
    private var imageName: String {
        (message.files?.firstObject as? File)?.name ?? ""
    }
    
    @ViewBuilder
    private var image: some View {
        SelfDownloadingImageView(name: imageName,
                                 placeholder: UIImage(named: "dark-placeholder")!,
                                 thumbnailSize: CGSize(width: 600, height: 300))
            .scaledToFill()
            .frame(minHeight: 100, maxHeight: 200)
            .cornerRadius(.messageBubbleCornerRadius)
            .clipped()
            .contentShape(Rectangle())
            .allowsHitTesting(true)
    }
}


#Preview {
    let body = """
    Before we continue to add previews of multiple
    different states of our SwiftUI button, we need to be able to display multiple previews.
    """

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

    func file(with id: String) -> File {
        let entity = NSManagedObjectModel.mergedModel(from: nil)?.entitiesByName["File"]
        let file = File(entity: entity!, insertInto: nil)
        file.name = id

        return file
    }

    return VStack(spacing: 8) {
        Spacer()
        Group {
            PhotoMessageCellView(message: photoMessage)
        }
        .padding(.horizontal)

        Spacer()
    }
    .background(.gray)
}
