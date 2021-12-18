//
//  PostModel.swift
//  TikTok
//
//  Created by mai ng on 7/26/21.
//

import Foundation


struct PostModel {
    let identifier: String
    let user:User
    var fileName: String = ""
    var caption: String = ""
        
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for x in 0...100 {
            let post = PostModel(identifier: UUID().uuidString,
                                 user:User(
                                    username: "mieng20",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString
                                ))
            posts.append(post)
        }
        return posts
    }
    
    var videoChildPath : String {
        return "videos/\(user.username.lowercased())/\(fileName )"
    }
}
 
