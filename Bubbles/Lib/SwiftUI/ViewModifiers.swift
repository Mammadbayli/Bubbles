//
//  ViewModifiers.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import Combine
import SwiftUI

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct Badge: ViewModifier {
    var count: Int?
    
    func body(content: Content) -> some View {
        if let count {
            content
                .overlay(alignment: .topLeading) {
                    BadgeView(label: String(count))
                        .offset(x: -8, y: -8)
                }
        } else {
            content
        }
    }
}

struct ProgressViewNavigationBar: ViewModifier {
    @State private var progressVisible = false
    private let connectionPublisher = NotificationCenter.default.publisher(for: .init(XMPP_STREAM_START_CONNECTING_NOTIFICATION))
    private let authenticationPublisher = NotificationCenter.default.publisher(for: .init(XMPP_STREAM_DID_AUTHENTICATE_NOTIFICATION))
    func body(content: Content) -> some View {
        content
            .onAppear{
                progressVisible = !XMPPController.sharedInstance().xmppStream.isConnected
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if progressVisible {
                        ProgressView()
                            .tint(.gray)
                    }
                }
            }.onReceive(connectionPublisher) { _ in
                progressVisible = true
            }
            .onReceive(authenticationPublisher) { _ in
                progressVisible = false
            }
    }
}

struct NFSNavigationTitle: ViewModifier {
    var title: String
    @State private var localizedNavigationTitle: String
    private let languagePublisher = NotificationCenter.default.publisher(for: .init("language-did-change"))
    func body(content: Content) -> some View {
        content
            .navigationTitle(localizedNavigationTitle)
            .onReceive(languagePublisher) { _ in
                localizedNavigationTitle = title.localized
            }
    }
    
    init(title: String) {
        self.title = title
        _localizedNavigationTitle = State(initialValue: title.localized)
    }
}

public extension Publishers {
    static var keyboardHeight: AnyPublisher<CGRect, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillChangeFrameNotification)
            .map { $0.keyboardFrame }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGRect.zero }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

public extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
    
    var keyboardFrame: CGRect {
        return userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
    }
}

public struct KeyboardAvoiding: ViewModifier {
    @State private var keyboardFrame: CGRect = .zero
    
    public func body(content: Content) -> some View {
        content
            .ignoresSafeArea(.keyboard)
            .padding(.bottom, keyboardFrame.height)
            .onReceive(Publishers.keyboardHeight) { frame in
                withAnimation {
                    keyboardFrame = frame
                }
            }
    }
}

extension View {
    func nfsBadge(count: Int?) -> some View {
        modifier(Badge(count: count))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func progressViewNavigationBar() -> some View {
        modifier(ProgressViewNavigationBar())
    }
    
    func nfsNavigationTitle(title: String) -> some View {
        modifier(NFSNavigationTitle(title: title))
            .progressViewNavigationBar()
    }
    
    func keyboardAvoiding() -> some View {
        modifier(KeyboardAvoiding())
    }
}

