//
//  Color.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

extension ShapeStyle where Self ==  Color {
    static var defaultText: Color {
        Color(uiColor: UIColor.text())
    }
    
    static var lightText: Color {
        Color(uiColor: UIColor.lightText())
    }
    
    static var nfsGreen: Color {
        Color(uiColor: UIColor.nfsGreen())
    }
    
    static var nfsGray: Color {
        Color(uiColor: UIColor.nfsGray())
    }
    
    static var lighterBackground: Color {
        Color(uiColor: UIColor.lighterBackground())
    }
    
    static var greenButton: Color {
        Color(uiColor: UIColor.greenButton())
    }
    
    static var textFieldBorder: Color {
        Color(uiColor: UIColor.textControlBorder())
    }
    
    static var outgoingMessageBubble: Color {
        Color(uiColor: UIColor.selfMessageBubble())
    }
    
    static var incomingMessageBubble: Color {
        Color(uiColor: UIColor.otherMessageBubble())
    }
    
    static var messageBubbleShadow: Color {
        Color(uiColor: UIColor.messageBubbleShadow())
    }
}

