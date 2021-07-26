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
    
    // Public
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
}


