//
//  HapticsManager.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import Foundation
import  UIKit



/// Object that deals with haptick feedback
final class HapticsManager {
    static let shared = HapticsManager()
    
    /// Private constructor
    private init() {}
    
    // Public
    
    
    /// Vibrate for light selection of item
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
             
            generator.prepare()
            generator.selectionChanged()
    
        }
    }
    
    
    /// Trigger feedback  vibration based in event typw
    /// - Parameter type: Success, Error, or Warning type
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
