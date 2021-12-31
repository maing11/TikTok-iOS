//
//  StorageManager.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import Foundation
import FirebaseStorage


/// Manage object that deals with firebase storage
final class StorageManager {
    /// Shared singlton instance
    public static let shared = StorageManager()
    
    /// Storage bucket reference
    private let storageBucket = Storage.storage().reference()
    /// privare constructor
    private init() {
//        uploadVideoURL(from: <#T##URL#>, fileName: <#T##String#>, completion: <#T##(Bool) -> Void#>)
    }
    
    // Public
    
    /// Upload a new user video firebase
    /// - Parameters:
    ///   - url: local file url to video
    ///   - fileName: Desired video file upload name
    ///   - completion: Async callback result closure
    public func uploadVideoURL(from url: URL,fileName: String,completion: @escaping(Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    /// Upload new profile picture
    /// - Parameters:
    ///   - image: New image to upload
    ///   - completion: async call back of result
    public func uploadProfilePicture(wiith image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        let path = "profile_picture/\(username)/picture.png"
        
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error  {
                completion(.failure(error))
            } else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))
                }
                
            }
        }
    }
    
    /// Generation a new file name
    /// - Returns: <#description#>
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }
    
    /// Get download url of video post
    /// - Parameters:
    ///   - post:  post model to get url for
    ///   - completion:  Async callback
    func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>)  -> Void) {
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error  {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
}
 
