//
//  UINavigationController+SwipeToGoback.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/5/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
