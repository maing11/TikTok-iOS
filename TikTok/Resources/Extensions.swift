//
//  Extensions.swift
//  TikTok
//
//  Created by mai ng on 7/26/21.
//

import Foundation
import  UIKit



extension UIView {
    
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
    
}

extension DateFormatter {
    static let defaultFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.timeZone = .current
        formater.locale = .current
        formater.dateStyle = .medium
        formater.timeStyle = .short
        return formater
        
    }()
}


extension String {
    static func date(with date: Date) -> String {
        return DateFormatter.defaultFormatter.string(from: date)
    }
}
