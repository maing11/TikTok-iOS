//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by mai nguyen on 10/18/21.
//

import Foundation
import UIKit




struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}

