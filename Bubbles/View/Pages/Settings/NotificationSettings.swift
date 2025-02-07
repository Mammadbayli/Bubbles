//
//  NotificationSettings.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/10/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

struct NotificationSettings: View {
    @State private var notificationsEnabled = RemoteNotificationsController.sharedInstance().isPushNotificationEnabled
    @State private var soundsSheetPresented = false
    @State private var selectedSoundId: String? = PersistencyManager.sharedInstance().getNotificationSoundId()

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack {
                    Toggle(isOn: $notificationsEnabled) {
                        LocalizedText("show_notifications")
                            .font(.tableCellText)
                            .foregroundStyle(.defaultText)
                    }
                }
                .padding(.horizontal)
                .frame(height: 50)

                Divider()

                HStack() {
                    LocalizedText("sound")
                        .font(.tableCellText)
                        .foregroundStyle(.defaultText)
                    Spacer()

                    if let selectedSoundId {
                        Text(selectedSoundId.stripFileExtension())
                            .font(.chatCellSubtitle)
                            .foregroundStyle(.defaultText)
                    }

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                .frame(height: 50)
                .contentShape(Rectangle())
                .onTapGesture {
                    soundsSheetPresented.toggle()
                }
            }
            .background(.lighterBackground)
        }
        .background(.defaultBackground)
        .nfsNavigationTitle(title: "settings_notfications_and_alerts")
        .sheet(isPresented: $soundsSheetPresented, content: {
            NotificationSounds(selectedSoundId: $selectedSoundId)
        })
        .onChange(of: notificationsEnabled) { newValue in
            if newValue {
                RemoteNotificationsController.sharedInstance().enablePushNotifications()
                    .catch { _ in
                        notificationsEnabled = false
                    }
            } else {
                RemoteNotificationsController.sharedInstance().disablePushNotifications()
                    .catch { _ in
                        notificationsEnabled = true
                    }
            }
        }
    }
}

struct NotificationSounds: View {
    @Binding var selectedSoundId: String?
    private let sounds: [String]

    init(selectedSoundId: Binding<String?>) {
        self._selectedSoundId = selectedSoundId
        let bundleRoot = Bundle.main.bundlePath
        if let dirContents = try? FileManager.default.contentsOfDirectory(atPath: bundleRoot) {
            sounds = dirContents.filter { $0.hasSuffix(".wav") }
        } else {
            sounds = []
        }
    }

    var body: some View {
        VStack(spacing: .zero) {
            LocalizedText("notification_sound_picker_title")
                .font(.postCellTitle)
                .foregroundStyle(.nfsGreen)
                .padding()

            List(sounds.indices, id: \.self) { index in
                let sound = sounds[index]
                NotificationSoundCell(sound: sound, selectedSoundId: $selectedSoundId)

            }
            .listStyle(.plain)
        }
    }
}

struct NotificationSoundCell: View {
    var sound: String
    @Binding var selectedSoundId: String?
    @State private var isLoading = false
    @State private var audioPlayer:AVAudioPlayer?

    var body: some View {
        HStack {
            Text(sound)
                .font(.tableCellText)
                .foregroundStyle(.defaultText)
                .padding(.vertical, 10)

            Spacer()
            if isLoading {
                ProgressView()
            } else if sound == selectedSoundId {
                Image(systemName: "checkmark")
                    .foregroundStyle(.nfsGreen)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }

    private func onTap() {
        if selectedSoundId != sound {
            isLoading = true
            RemoteNotificationsController
                .sharedInstance()
                .saveSoundPreference(sound)
                .pipe { _ in
                    isLoading = false
                    selectedSoundId = sound
                }
        }

        if let url = Bundle.main.url(forResource: sound, withExtension: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print(error)
            }
        }
    }
}

@objc class NotificationSettingsViewContainer: NSObject {
    @objc static func create() -> UIViewController {
        let view = NotificationSettings()
        let hostingController = HostingViewController(rootView: view)
        return hostingController
    }
}

#Preview {
    ZStack {
        Rectangle()
            .foregroundColor(.defaultBackground)
        NotificationSettings()
            .frame(height: 400)
    }
}

extension String {
    func stripFileExtension () -> String {
        var components = self.components(separatedBy: ".")
        guard components.count > 1 else { return self }
        components.removeLast()
        return components.joined(separator: ".")
    }
}
