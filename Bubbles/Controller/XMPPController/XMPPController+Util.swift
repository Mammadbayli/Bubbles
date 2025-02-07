//
//  XMPPController+Util.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/25/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import Foundation
import XMPPFramework

@objc
extension XMPPController {
    func sendReadReceiptForMessage(_ message: Message) {
        if let jid = message.from?.jid(), message.isUnread {
            let child = DDXMLElement(name: "read", xmlns: "urn:xmpp:receipts")
            child.addAttribute(withName: "id", stringValue: message.uniqueId)
            let message = XMPPMessage(type: "chat",
                                      to: jid,
                                      elementID: nil,
                                      child: child)
            xmppStream.send(message)
        }
    }
}
