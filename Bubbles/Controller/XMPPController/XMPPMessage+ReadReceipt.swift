//
//  XMPPMessage+ReadReceipt.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/25/24.
//  Copyright © 2024 Javad Mammadbayli. All rights reserved.
//

import Foundation
import XMPPFramework

@objc
extension XMPPMessage {
    var readReceiptID: String? {
        elements(forName: "read").first?.attributeStringValue(forName: "id")
    }
    
    var deliveredReceiptID: String? {
        receiptResponseID
    }
}
