//
//  SwitchCellViewModel.swift
//  TikTok
//
//  Created by mai nguyen on 12/28/21.
//

import Foundation


struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
