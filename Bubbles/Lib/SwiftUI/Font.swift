//
//  Font.swift
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/30/23.
//  Copyright © 2023 Javad Mammadbayli. All rights reserved.
//

import SwiftUI

extension Font {
    static var postCellTitle: Font {
        Font(UIFont.postCellTitle())
    }
    
    static var postCellSuibtitle: Font {
        Font(UIFont.postCellSubtitle())
    }
    
    static var postCellBody: Font {
        Font(UIFont.postContent())
    }
    
    static var icomoon: Font {
        Font(UIFont.icomoon())
    }
   
    static var icomoon13: Font {
        Font(UIFont.icomoon().withSize(13))
    }
    
    static var icomoon16: Font {
        Font(UIFont.icomoon().withSize(16))
    }
    
    static var defaultText: Font {
        Font(UIFont.text())
    }
    
    static var defaultText20: Font {
        Font(UIFont.text().withSize(20))
    }
    
    static var commentCellTitle: Font {
        Font(UIFont.postCommentTitle())
    }
    
    static var commentCellTimestamp: Font {
        Font(UIFont.postCommentDate())
    }
    
    static var commentCellBody: Font {
        Font(UIFont.postCommentText())
    }
    
    static var navigationTitleSmall: Font {
        Font(UIFont.navigationSmallTitle())
    }
    
    static var navigationTitle: Font {
        Font(UIFont.navigationTitle())
    }
    
    static var navigationSubtitle: Font {
        Font(UIFont.navigationSubtitle())
    }
    
    static func nfs(size: CGFloat) -> Font {
        Font(UIFont.nfs().withSize(size))
    }
    
    static var rosterCellTitle: Font {
        Font(UIFont.rosterCellTitle())
    }
    
    static var rosterCellSubtitle: Font {
        Font(UIFont.rosterCellSubtitle())
    }
    
    static var tableCellText: Font {
        Font(UIFont.tableCellText())
    }
    
    static var chatMessageDetails: Font {
        Font(UIFont.messageBottomItems())
    }
    
    static var chatCellTitle: Font {
        Font(UIFont.chatCellTitle())
    }
    
    static var chatCellSubtitle: Font {
        Font(UIFont.chatCellSubtitle())
    }
}
