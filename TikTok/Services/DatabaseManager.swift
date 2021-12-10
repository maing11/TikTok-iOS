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
        
//        database.child(username).setValue(["email": email]) { error, _ in
//            guard let error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        }
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
//            print(snapshot.value)
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                // create users root node
                self?.database.child("users").setValue(
                    [
                        username:[
                     "email": email
                    ]
                  ]
                ) {error,_ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }
            usersDictionary[username] = ["email":email]
            //save new users object
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard  error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    public func getUsername(for email: String, completion: @escaping (String?) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String:[String: Any]] else {
                completion(nil)
                return
            }
            
            for (username, value) in users {
                if value["email"] as? String == email {
                    completion(username)
                    break
                }
            }
        }
    }

    public func inserPost(filename: String,caption: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            let newEntry = [
                "name": filename,
                "caption": caption]
            
            if var post = value["posts"] as? [[String: Any]] {
                post.append(newEntry)
                
                value["posts"] = post
                
                self?.database.child("users").child(username).setValue(value) {error,_ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else {
                value["posts"] = [newEntry]
                self?.database.child("users").child(username).setValue(value) {error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                
            }
        }
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
