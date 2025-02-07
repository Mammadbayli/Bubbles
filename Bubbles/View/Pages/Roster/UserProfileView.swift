//
//  UserProfileView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/14/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    private let username: String
    
    var body: some View {
        UserProfile(username: username)
            .nfsNavigationTitle(title: username.uppercased())
             .navigationBarTitleDisplayMode(.inline)
    }
    
    init(username: String) {
        self.username = username
    }
}

struct UserProfile: UIViewControllerRepresentable {
    typealias UIViewControllerType = AccountViewController
    var username: String
    
    func makeUIViewController(context: Context) -> AccountViewController {
        return AccountViewController(user: username)
    }
    
    func updateUIViewController(_ uiViewController: AccountViewController, context: Context) {
        
    }
}
