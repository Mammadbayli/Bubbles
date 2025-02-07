//
//  NFSTabView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 4/27/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct NFSTabView: View {
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            RosterView()
                .tabItem {
                    let symbolConfiguration = UIImage.SymbolConfiguration(weight: .medium)
                    Image(uiImage: UIImage(named: "tabbar-friends",
                                           in: Bundle.main,
                                           with: symbolConfiguration)!)
                }
                .tag(0)
            
            ChatsView()
                .tabItem {
                    let symbolConfiguration = UIImage.SymbolConfiguration(weight: .medium)
                    Image(uiImage: UIImage(named: "tabbar-message",
                                           in: Bundle.main,
                                           with: symbolConfiguration)!)
                }
                .tag(1)
            
            ChatRoomCategoriesView()
                .tabItem {
                    let symbolConfiguration = UIImage.SymbolConfiguration(weight: .medium)
                    Image(uiImage: UIImage(named: "tabbar-network",
                                           in: Bundle.main,
                                           with: symbolConfiguration)!)
                }
                .tag(2)
            
            AccountView(user: PersistencyManager.sharedInstance().getUsername(), isViewingSelf: true)
                .background(.defaultBackground)
                .tabItem {
                    let symbolConfiguration = UIImage.SymbolConfiguration(weight: .medium)
                    Image(uiImage: UIImage(named: "tabbar-gear",
                                           in: Bundle.main,
                                           with: symbolConfiguration)!)
                }
                .tag(3)
        }
        .tint(.nfsGreen)
        .onReceive(NotificationCenter.default.publisher(for: .navigateToRoster)) { value in
            selection = 0
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToChat)) { value in
            selection = 1
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToPost)) { value in
            selection = 2
        }
    }
}

@objc class NFSTabViewContainer: NSObject {
    private let view = NFSTabView()
    @objc var viewController: UIViewController!
    
    override init() {
        super.init()
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        viewController = HostingViewController(rootView: view.environment(\.managedObjectContext,
                                                                           CoreDataStack.sharedInstance().mainContext))
        
        viewController.accessibilityLabel = "tabbar"
    }
}
