//
//  CaptionViewController.swift
//  TikTok
//
//  Created by mai nguyen on 12/7/21.
//

import UIKit
import ProgressHUD

class CaptionViewController: UIViewController {

    var videoURL: URL
    
    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        view.addSubview(captionTextView)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top + 5, width: view.width - 10, height: 150).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
        @objc private func didTapPost() {
            captionTextView.resignFirstResponder()
            let caption = captionTextView.text ?? ""
            // Generate video name that is uniques based on Id
            let newVideoName = StorageManager.shared.generateVideoName()
            
            ProgressHUD.show("Posting")
            // Upload video
            StorageManager.shared.uploadVideoURL(from: videoURL, fileName:newVideoName) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        // Update database
                        
                        DatabaseManager.shared.inserPost(filename: newVideoName,caption: caption) { databaseUpdated in
                            if databaseUpdated {
                                HapticsManager.shared.vibrate(for: .success)
                                ProgressHUD.dismiss()

                                // Reset cameara and switch to feed
                                self?.navigationController?.popToRootViewController(animated: true)
                                self?.tabBarController?.selectedIndex = 0
                                self?.tabBarController?.tabBar.isHidden = false

                            } else {
                                HapticsManager.shared.vibrate(for: .error)
                                ProgressHUD.dismiss()
                                let alert = UIAlertController(title: "Woops",
                                                              message: "We are unable to upload your video. Please try again", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                self?.present(alert, animated: true)
                                
                            }
                        }
                        
                    }
                    else {
                        HapticsManager.shared.vibrate(for: .error)
                        ProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Woops",
                                                      message: "We are unable to upload your video. Please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
}
