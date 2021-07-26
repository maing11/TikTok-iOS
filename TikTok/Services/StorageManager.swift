//
//  StorageManager.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import Foundation
import FirebaseStorage


final class StorageManager {
    public static let shared = StorageManager()
    
    
    private let database = Storage.storage().reference()
    private init() {}
    
    // Public
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {
        
    }
    
    public func uploadVideoURL(from url: URL) {
        
    }
}
 
