//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by mai nguyen on 10/18/21.
//

import Foundation
import UIKit

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}

