//
//  AccountView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 4/27/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct AccountView: UIViewControllerRepresentable {
    var user: String
    var isViewingSelf: Bool
    
    typealias UIViewControllerType = NavigationController
    
    func makeUIViewController(context: Context) -> NavigationController {
        let vc = AccountViewController(user: user, andIsViewingSelf: isViewingSelf)
        return NavigationController(rootViewController: vc)
    }
    
    func updateUIViewController(_ uiViewController: NavigationController, context: Context) {
        
    }
}

