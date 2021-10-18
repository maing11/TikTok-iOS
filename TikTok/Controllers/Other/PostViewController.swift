//
//  PostViewController.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import UIKit
import AVFoundation
import  AVKit

protocol  PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController,didTapCommentButtonFor post: PostModel )
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor Post: PostModel)
}





class PostViewController: UIViewController {
    
    var model: PostModel
    weak var delegate: PostViewControllerDelegate?
    
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit

        
        return button
    }()
    
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Test"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Check out this video! #fyp #foryou #foryoupage"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
        
    }()
    
    var player: AVPlayer?
    
    
    // MARK: - Init
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo()

        let colors : [UIColor] = [.red, .green,.black,.orange,.blue,.systemPink]
        view.backgroundColor = colors.randomElement()
        
        setUpButtons()
        setUpDoubleTapToLike()
        
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size: CGFloat = 40
        let tabBarHeight: CGFloat = (tabBarController?.tabBar.height ?? 0)
        let yStart: CGFloat = view.height - (size * 4.0) - 30 - view.safeAreaInsets.bottom - tabBarHeight
//            $0.frame = CGRect(x: view.width - size - 5, y: yStart + (), width: size, height: size)
        
        for (index, button) in [likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size - 10, y: yStart + (CGFloat(index)*10) + (CGFloat(index)*size), width: size, height: size)
        }
        
        captionLabel.sizeToFit()
        
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(x: 5,
                                    y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height - (tabBarController?.tabBar.height ?? 0 ),
                                    width: view.width - size - 12,
                                    height: labelSize.height)
        
        
        profileButton.frame = CGRect(x: likeButton.left,
                                     y: likeButton.top - 10 - size,
                                     width: size,
                                     height:size)
        
        profileButton.layer.cornerRadius = size/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureVideo()
    }
    
    
    func setUpButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)

    }
    


    private func configureVideo() {
        // guard let because this path for resource might actually be nil
        guard let path = Bundle.main.path(forResource: "cocacola", ofType: "mp4") else { return }

        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)

            let playerlayer = AVPlayerLayer(player: player)

            playerlayer.frame = view.bounds
            playerlayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(playerlayer)
        player?.volume = 0
            player?.play()

            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
            self.present(playerViewController, animated: true) {
               playerViewController.player!.play()
           }
       }

    @objc func didTapProfileButton() {
        delegate?.postViewController(self, didTapProfileButtonFor: model)
        
    }
    
    @objc private func didTapLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed :.white
    }
    
    @objc private func didTapComment() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
                
       
        }
        
    
    @objc private func didTapShare() {
        guard let url = URL(string: "https://www.tiktok.com") else {return}
        
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(vc, animated: true)
        
    }
    

    func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
         
    }
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        }
        
        let touchPoint = gesture.location(in: view)
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.tintColor = .systemRed
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.3) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    UIView.animate(withDuration: 0.2) {
                        imageView.alpha = 0
                    } completion: { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
        }
        
    }

}
