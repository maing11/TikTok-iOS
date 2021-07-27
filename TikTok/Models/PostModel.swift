//
//  PostModel.swift
//  TikTok
//
//  Created by mai ng on 7/26/21.
//

import Foundation


struct PostModel {
    let identifier: String
    
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for x in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
    
}
 
