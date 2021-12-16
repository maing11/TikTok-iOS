//
//  Notifications.swift
//  TikTok
//
//  Created by mai nguyen on 12/14/21.
//

import Foundation



enum NotificationType {
    case postLike(postName: String)
    case userFolow(userName:String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .postLike: return "postLike"
        case .userFolow: return "userFollow"
        case .postComment: return "postComment"
        }
    }
}

class Notification {
    var identifier  = UUID().uuidString
    var isHidden = false
    let text: String
    let type: NotificationType
    let date: Date
    
    init(text: String, type: NotificationType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    
    static func mockData() -> [Notification]{
     
        
        let first =  Array(0...5).compactMap {
            Notification(
                text: "Something happened \($0)",
                type: .postLike(postName: "abcdc"),
                date: Date())
        }
        let second =  Array(0...5).compactMap {
            Notification(
                text: "Something happened \($0)",
                type: .userFolow(userName: "abcdc"),
                date: Date())
        }
   
        
        let third =  Array(0...5).compactMap {
            Notification(
                text: "Something happened \($0)",
                type: .postComment(postName: "abcdc"),
                date: Date())
        }
        return first + second + third
    }
}
