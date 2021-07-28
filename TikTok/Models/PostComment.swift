//
//  PostComment.swift
//  TikTok
//
//  Created by mai ng on 7/27/21.
//

import Foundation


struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    
    static func mockComments() -> [PostComment] {
        let user = User(username: "Justin BieBer",
                        profilePictureURL: nil,
                        identifier: UUID().uuidString)
        
        var comments = [PostComment]()
        
        let text = ["This is cool",
                    "this is rad",
                    "I'm learning so much!"]
        
        for comment in text {
            comments.append(PostComment(text: comment,
                                        user: user,
                                        date: Date())
            )
        }
        return comments
    }
}
