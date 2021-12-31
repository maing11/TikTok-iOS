//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import Foundation
import FirebaseAuth


/// Manager responsibility for singing in , up and out
final class AuthManager {
    /// Singleton instance of manager
    public static let shared = AuthManager()
    
    // Private constructor
    private init() {}
    
    /// Represents method to sign in
    enum SignInMethod {
        /// Email and password method
        case email
        /// Facebook method
        case facebook
        // Google Account method
        case google
    }
    
    /// Represent errors that can occur in auth flows
    enum AuthError: Error {
        case signInFailed
    }
    
    // Public
    
    /// Represent if user is signed in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    /// Attempt to sign in
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async result callback
    public func signIn(with email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard  result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            //Successful Sign in
            
            DatabaseManager.shared.getUsername(for: email) { username in
                UserDefaults.standard.setValue(username, forKey: "username")
                print("Got username: \(username)")
            
            }
            completion(.success(email))

        }
    }
    /// Attemp to sign up
    /// - Parameters:
    ///   - username: Desired username
    ///   - emailAdress: User email
    ///   - password: User password
    ///   - completion: Async result callback
    public func signUp(with username: String,
                       emailAdress: String,
                       password: String,
                       completion:@escaping(Bool) -> Void) {
        
        // Make sure enterd username is available
        Auth.auth().createUser(withEmail: emailAdress, password: password) { result, error in
            guard  result != nil, error == nil  else {
                completion(false)
                return
            }
            UserDefaults.standard.setValue(username, forKey: "username")
            DatabaseManager.shared.insertUser(with: emailAdress, username: username, completion: completion)
        }
        
    }



    
    
    /// Attempt to sign up
    /// - Parameter completion: Async callback of sign out result
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


