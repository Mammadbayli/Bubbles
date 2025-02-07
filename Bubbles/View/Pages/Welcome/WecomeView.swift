//
//  WecomeView.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/6/25.
//  Copyright © 2025 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorText: String?
    @State private var viewState = ViewState.initial

    var body: some View {
        VStack(alignment: .center) {
            Spacer()

            Image("chat-bubbles-abstract")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .onTapGesture {
                    withAnimation {
                        viewState = .registeredUser
                    }
                }

            Spacer()

            VStack(alignment: .center) {
                switch viewState {
                case .initial:
                    usernameInput
                case .newUser:
                    usernameInput
                case .registeredUser:
                    usernameInput
                    passwordInput
                }

                errorDisplay

                button
                    .padding(.top)
            }
            .frame(width: 300)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.defaultBackground)
        .onChange(of: password) { value in
            if value.range(of: PASSWORD_REGEX, options: .regularExpression) == nil {
                errorText = "Insecure password"
            } else {
                errorText = nil
            }
        }
        .onReceive(
            username.publisher
        ) { _ in
            if username.range(of: USERNAME_REGEX, options: .regularExpression) == nil {
                errorText = "Invalid username"
            } else {
                errorText = nil
                checkUserExists()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(XMPP_STREAM_DID_AUTHENTICATE_NOTIFICATION))) { _ in
            PersistencyManager.sharedInstance().savePassword(password)
            ActivityIndicatorPresenter.sharedInstance().dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(XMPP_STREAM_DID_NOT_AUTHENTICATE_NOTIFICATION))) { _ in
            errorText = "invalid_credentials".localized
            ActivityIndicatorPresenter.sharedInstance().dismiss()
        }
    }

    @ViewBuilder
    private var errorDisplay: some View {
        if let errorText {
            Text(errorText)
                .font(.defaultText)
                .foregroundStyle(.red)
        }
    }

    @ViewBuilder
    private var usernameInput: some View {
        JTextField("username", text: $username)
    }

    @ViewBuilder
    private var passwordInput: some View {
        JTextField("password", text: $password)
    }

    @ViewBuilder
    private var button: some View {
        NFSButton(label: "Done", style: .green(internalPadding: 16, fullWidth: true)) {
            ActivityIndicatorPresenter.sharedInstance().present()
            XMPPController.sharedInstance().authenticate(withUsername: username, andPassword: password)
        }
            .frame(maxWidth: .infinity)
    }

    private func checkUserExists() {
        ActivityIndicatorPresenter.sharedInstance().present()
        ProfileController.sharedInstance().getProfileForUsername(username)
            .pipe { res in
                switch  res {
                case .fulfilled(let result):
                    viewState = .registeredUser
                case .rejected(let error):
                    switch (error as NSError).code {
                    case -1011:
                        viewState = .newUser
                    default:
                        AlertPresenter.sharedInstance()
                            .presentError(withMessage: error.localizedDescription)
                    }
                }

                ActivityIndicatorPresenter.sharedInstance().dismiss()
            }
    }

    private enum ViewState {
        case initial
        case newUser
        case registeredUser
    }
}

#Preview {
    WelcomeView()
}

class WelcomeViewContainer: NSObject {
    @objc static func create() -> UIViewController {
        let view = WelcomeView()
        let hostingController = HostingViewController(rootView: view)
        return hostingController
    }
}

struct JTextField: View {
    var localizedLabelKey: String
    @Binding var text: String

    init(_ localizedLabelKey: String, text: Binding<String>) {
        self.localizedLabelKey = localizedLabelKey
        self._text = text
    }

    var body: some View {
        TextField(
            localizedLabelKey.localized,
            text: $text
        )
        .autocorrectionDisabled()
        .font(.defaultText)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.textFieldBorder, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                )
        )
        .frame(maxHeight: .inputFieldHeight)
    }
}
