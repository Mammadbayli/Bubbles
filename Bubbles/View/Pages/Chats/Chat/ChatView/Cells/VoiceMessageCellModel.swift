//
//  VoiceMessageCellViewModel.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/1/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

@MainActor
class VoiceMessageCellModel: NSObject, ObservableObject {
    @Published var remainingDurationString = 0.string
    @Published var isPlaying = false
    @Published var progress: Double = 0.0
    
    private let player: AVController
    private var data: Data?
    private var identifier: String = ""
    private var duration: Double = 0
    private var currentTime: Double = 0 {
        didSet {
            progress = currentTime/duration
            remainingDurationString = (duration - currentTime).string
        }
    }
    
    init(message: VoiceMessage, player: AVController = AVController.sharedInstance()) {
        self.player = player
        
        super.init()
        
        guard let file = (message.files?.firstObject as? File) else { return }
        file.download().pipe {[weak self] result in
            switch result {
            case .fulfilled(let data):
                self?.data = data as? Data
            case .rejected(let error):
                print(error)
            }
        }
        
        identifier = file.name
        duration = message.duration
        remainingDurationString = message.duration.string
        isPlaying = player.isPlayingAudio(withIdentifier: identifier)
        
        registerObservers()
    }
    
    func play() {
        guard let data else { return }
        if player.isPlayingAudio(withIdentifier: identifier) {
            player.pausePlayback()
        } else {
            player.playAudioData(data, withIdentifier: identifier)
        }
    }
}

extension VoiceMessageCellModel {
    func registerObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name(AVCONTROLLER_PLAYBACK_DID_STOP),
                                               object: nil,
                                               queue: nil) {[weak self] notif in
            guard let identifier = notif.userInfo?["identifier"] as? String,
                  identifier == self?.identifier else { return }
            self?.playbackDidStop(withIdentifier: identifier)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(AVCONTROLLER_PLAYBACK_DID_START),
                                               object: nil,
                                               queue: nil) {[weak self] notif in
            guard let identifier = notif.userInfo?["identifier"] as? String,
                  identifier == self?.identifier else { return }
            self?.playbackDidStart(withIdentifier: identifier)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(AVCONTROLLER_PLAYBACK_DID_RESUME),
                                               object: nil,
                                               queue: nil) {[weak self] notif in
            guard let identifier = notif.userInfo?["identifier"] as? String,
                  identifier == self?.identifier else { return }
            self?.playbackDidResume(withIdentifier: identifier)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(AVCONTROLLER_PLAYBACK_DID_PAUSE),
                                               object: nil,
                                               queue: nil) {[weak self] notif in
            guard let identifier = notif.userInfo?["identifier"] as? String,
                  identifier == self?.identifier else { return }
            self?.playbackDidPause(withIdentifier: identifier)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(AVCONTROLLER_PLAYBACK_DID_FINISH),
                                               object: nil,
                                               queue: nil) {[weak self] notif in
            guard let identifier = notif.userInfo?["identifier"] as? String,
                  identifier == self?.identifier else { return }
            self?.playbackDidFinish(withIdentifier: identifier)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(AVCONTROLLER_PLAYBACK_CURRENT_TIME_DID_CHANGE),
                                               object: nil,
                                               queue: OperationQueue.main) {[weak self] notif in
            guard let identifier = notif.userInfo?["identifier"] as? String,
                  identifier == self?.identifier,
                  let currentTime = notif.userInfo?["currentTime"] as? NSNumber
            else { return }
            self?.playbackCurrentTimeDidChange(currentTime.doubleValue, withIdentifier: identifier)
        }
    }
    
    @objc
    func playbackDidStop(withIdentifier identifier: String) {
        isPlaying = false
        currentTime = 0
    }
    
    @objc
    func playbackDidStart(withIdentifier identifier: String) {
        isPlaying = true
    }
    
    @objc
    func playbackDidResume(withIdentifier identifier: String) {
        isPlaying = true
    }
    
    @objc
    func playbackDidPause(withIdentifier identifier: String) {
        isPlaying = false
    }
    
    @objc
    func playbackDidFinish(withIdentifier identifier: String) {
        isPlaying = false
        currentTime = 0
    }
    
    @objc
    func playbackCurrentTimeDidChange(_ currentTime: TimeInterval, withIdentifier identifier: String) {
        self.currentTime = currentTime
    }
}

extension TimeInterval {
    var string: String {
        let duration = Int(self)
        let minutes = duration/60
        let seconds = duration%60
        let secondsPrefix = seconds/10
        let secondsSuffix = seconds%10
        
        return "\(minutes):\(secondsPrefix)\(secondsSuffix)"
    }
}
