//
//  SelfDownloadingImageView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct SelfDownloadingImageView: View {
    private let name: String
    private let placeholder: UIImage
    private let thumbnailSize: CGSize?
    @State private var image: UIImage?
    
    var body: some View {
        Image(uiImage: image ?? placeholder)
            .resizable()
            .task {
                downloadImage()
            }
    }

    private func downloadImage() {
        PersistencyManager.sharedInstance().file(withName: name).pipe { result in
            switch result {
            case .fulfilled(let data):
                guard
                    let data = data as? Data,
                    let image = UIImage(data: data)
                else { return }

                if let thumbnailSize {
                    image.prepareThumbnail(of: thumbnailSize) { thumbnail in
                        DispatchQueue.main.async {
                            self.image = thumbnail
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            case .rejected(let error):
                self.image = placeholder
            }
        }
    }

    init(name: String,
         placeholder: UIImage = UIImage(),
         thumbnailSize: CGSize? = nil) {
        self.name = name
        self.placeholder = placeholder
        self.thumbnailSize = thumbnailSize
    }
}

