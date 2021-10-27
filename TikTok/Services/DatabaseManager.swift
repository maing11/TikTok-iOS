//
//  DatabaseManager.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    
    private let database = Database.database().reference()
    
    private init() {}
    
    // Public
    
    public func insertUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        // get current users key
        // insert new entry
        // create root users
        
        database.child("users").observeSingleEvent(of: .value) {[weak self] snapshot in
            guard var userDictionary = snapshot.value as?  [String: Any] else {
                // create users root node
                self?.database.child("users").setValue(
                    [
                        username: [
                            "email": email
                        ]
                    ]
                    
                
                ){ error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }
//            userDictionary[username] = ["email: email"]
//            // save new users object
//            self?.database.child("users").setValue(userDictionary,withCompletionBlock: { error, _ in
//                guard error == nil else {
//                    completion(false)
//                    return
//                }
//                completion(true)
//            })
        }
//
        database.child(username).setValue(["email": email]) {error,_ in
            guard error == nil else {
                completion(false)
                return
            }
        }
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
