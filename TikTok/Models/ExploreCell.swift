//
//  ExploreCell.swift
//  TikTok
//
//  Created by mai nguyen on 10/18/21.
//

import Foundation
import UIKit



enum ExploreCell {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel )
}


