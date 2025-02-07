//
//  HostingViewController.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/13/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

class HostingViewController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.nfsGreen(),
            .font: UIFont.navigationTitle()
        ]
        
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.nfsGreen(),
            .font: UIFont.navigationSmallTitle()
        ]
    }
}
