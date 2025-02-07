//
//  SelfDownloadingAvatarView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import CoreData
import SwiftUI

struct SelfDownloadingAvatarView: View {
    @FetchRequest(sortDescriptors:[]) private var photos: FetchedResults<UserPhoto>
    private let username: String
    
    private var avatarKey: String {
        photos.first?.name ?? ""
    }
    
    var body: some View {
        SelfDownloadingImageView(name: avatarKey,
                                 placeholder: UIImage(named: "user")!,
                                 thumbnailSize: CGSize(width: 120, height: 120))
            .scaledToFill()
            .frame(width: .avatarSize, height: .avatarSize, alignment: .center)
            .clipped()
            .cornerRadius(.avatarCornerRadius)
            .id(avatarKey)
            .onAppear {
                ProfileController.sharedInstance().getProfileForUsername(username)
            }
    }
    
    init(username: String) {
        self.username = username
        let predicate = NSPredicate(format: "username == %@", username)
        _photos = FetchRequest(entity: UserPhoto.entity(), sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)], predicate: predicate)
    }
}
