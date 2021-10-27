//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import Foundation
import FirebaseAuth


final class AuthManager {
    public static let shared = AuthManager()
    
    
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    enum AuthError: Error {
        case signInFailed
    }
    
    // Public
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    public func signIn(with email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard  result != nil, error == nil else {
                if let error  = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            
            
        }
    }
    
    public func signUp(with username: String,
                       emailAdress: String,
                       password: String,
                       completion:@escaping(Bool) -> Void) {
        // Make sure enterd username is available
        
        
        Auth.auth().createUser(withEmail: emailAdress, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            DatabaseManager.shared.insertUser(with: emailAdress, username: username, completion: completion)
            
        }
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try  Auth.auth().signOut()
            completion(true)
        } catch {
           print(error)
            completion(false)
        }
    }
}


