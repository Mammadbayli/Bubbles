//
//  ChatViewModel+Recording.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/4/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

extension ChatViewModel: AVControllerRecordingDelegate {
    func generateHaptic() {
        hapticGenerator.impactOccurred()
    }
    
    func startRecording() {
        AVAudioSession.sharedInstance().requestRecordPermission {[weak self] granted in
            if granted {
                DispatchQueue.main.async {
                    self?.recorder.recordingDelegate = self
                    self?.recorder.startRecording()
                }
            } else {
                AlertPresenter.sharedInstance().presentError(withMessage: "Cannot get recording permission")
            }
        }
    }
    
    func stopRecording() {
        recorder.finishRecording()
    }
    
    func cancelRecording() {
        stopRecording()
        recorder.cancelRecording()
    }
    
    func recordingDidStart() {
        
    }
    
    func recordingDidCancel() {
        
    }
    
    func recordingDidFinish(with data: Data) {
        sendVoiceMessage(with: data)
    }
    
    func recordingElapsedDurationDidChange(_ duration: TimeInterval) {
        self.recordingDuration = duration
    }
}
