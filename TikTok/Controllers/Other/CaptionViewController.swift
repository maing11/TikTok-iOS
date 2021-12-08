//
//  CaptionViewController.swift
//  TikTok
//
//  Created by mai nguyen on 12/7/21.
//

import UIKit

class CaptionViewController: UIViewController {

    var videoURL: URL
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done
                                                            , target: <#T##Any?#>, action: <#T##Selector?#>)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    

   

}
