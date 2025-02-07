//
//  ChatViewModel+ImagePicker.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/4/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

extension ChatViewModel: MediaPickerControllerDelegate {
    func mediaPickerControllerDidFinishPicking(_ media: [Any]!, andText text: String!) {
        for item in media {
            if let item = item as? UIImage,
               let data = item.jpegData(compressionQuality: 1) {
                sendPohotMessage(with: data, andBody: text)
            }
        }
    }
}

extension ChatViewModel {
    func showImagePickerWith(source: MediaPickerControllerSource) {
        mediaPicker.delegate = self
        mediaPicker.pickMedia(from: source)
    }
}
