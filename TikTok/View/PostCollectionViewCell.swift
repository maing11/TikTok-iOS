//
//  PostCollectionViewCell.swift
//  TikTok
//
//  Created by mai nguyen on 12/17/21.
//

//
//  PostUICollectionViewCell.swift
//  TikTok
//
//  Created by mai nguyen on 12/17/21.
//

import UIKit
import AVFoundation

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(with post: PostModel) {
        StorageManager.shared.getDownloadURL(for: post) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("got url:\(url)")
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        self.imageView.image = UIImage(cgImage: cgImage)

                    } catch {
                        
                    }
                case .failure(let error):
                    print("failed to get download url: \(error)")
                    
                }
            }
           
        }
        // Get download url
        
        // Generate thumbnail
    
    }
}
