//
//  ExploreSectionType.swift
//  TikTok
//
//  Created by mai nguyen on 10/18/21.
//

import Foundation


enum ExploreSectionType {
    case banners
    case trendingPosts
    case users
    case trendingHashtags
    case recommended
    case popular
    case new
    
    var title: String {
        switch self {
        case .banners:
            return "Features"
        case .trendingPosts:
            return "Trendding Videos"
        case .users:
            return "Popular Creators"
        case .trendingHashtags:
            return "Hashtags"
        case .recommended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"
        }
    }
    
}

