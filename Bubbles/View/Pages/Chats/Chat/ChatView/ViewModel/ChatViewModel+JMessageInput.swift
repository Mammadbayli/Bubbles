//
//  ChatViewModel+JMessageInput.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/29/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import JMessageInput

extension ChatViewModel: JMessageInputDelegate {
    func inputDidEndEditing(input: JMessageInput) {
        XMPPController.sharedInstance().pauseComposing(withChatId: chatId)
    }
    
    func inputDidBeginEditing(input: JMessageInput) {
        XMPPController.sharedInstance().startComposing(withChatId: chatId)
    }
    
    func textDidChange(input: JMessageInput, text: String?) {
        if (text?.count ?? 0) > 0 {
            input.state = .dirty
        } else {
            input.state = .initial
        }
    }
    
    func inputDidComeIntoFocus(input: JMessageInput) {
        
    }
    
    func inputDidFallOutOfFocus(input: JMessageInput) {
        
    }
    
    func inputDidChangeFrame(input: JMessageInput, frame: CGRect) {
        
    }
    
    func inputWillChangeFrame(input: JMessageInput, frame: CGRect) {
        
    }
    
    func micButtonPressed(input: JMessageInput) {
        startRecording()
        generateHaptic()
    }
    
    func micButtonReleased(input: JMessageInput, canceled: Bool) {
        if canceled {
            cancelRecording()
        } else {
            stopRecording()
        }
        generateHaptic()
    }
    
    func plusButtonPressed(input: JMessageInput) {
        
    }
    
    func plusButtonReleased(input: JMessageInput) {
        attachmentOptionsPresented = true
    }
    
    func sendButtonPressed(input: JMessageInput) {
        
    }
    
    func sendButtonReleased(input: JMessageInput) {
        let cleanedText = input.text?.trimmingCharacters(in: CharacterSet(charactersIn: " \n"))
        if let cleanedText, cleanedText.count > 0 {
            sendTextMessage(with: cleanedText)
        }
        input.text = nil
    }
    
    func cameraButtonPressed(input: JMessageInput) {
        showImagePickerWith(source: .camera)
    }
    
    func cameraButtonReleased(input: JMessageInput) {
        
    }
}
