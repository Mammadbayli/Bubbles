//
//  AddFriendView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/14/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct AddFriendView: UIViewControllerRepresentable {
    typealias UIViewControllerType = NavigationController
    
    func makeUIViewController(context: Context) -> NavigationController {
        let addFriendVC = AddFriendViewController()
        return NavigationController(rootViewController: addFriendVC)
    }
    
    func updateUIViewController(_ uiViewController: NavigationController, context: Context) {
        
    }
}
