//
//  ChatViewModel+PhotoViewer.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/4/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

extension ChatViewModel {
    func viewPhotosFor(message: ChatMessage) {
        message.managedObjectContext?.perform {
            let photoViewer = PhotoViewerController()
            
            var files = [File]()
            
            for element in message.chat?.messages?.array ?? [] {
                guard let element = element as? PhotoMessage else { continue }
                if let filesArray = element.files?.array as? [File], !filesArray.isEmpty {
                    files.append(contentsOf: filesArray)
                }
            }
            
            let selectedIndex = files.firstIndex { file in
                file.name == (message.files?.firstObject as? File)?.name
            } ?? 0
            
            photoViewer.viewPhotos(files.map { $0.name },
                                   withSelectedIndex: selectedIndex.magnitude)
            
            photoViewer.titleForIndex = { index in
                files[Int(index)].message?.from?.uppercased()
            }
            
            photoViewer.subtitleForIndex = { index in
                files[Int(index)].message?.timestampString
            }
        }
    }
}
