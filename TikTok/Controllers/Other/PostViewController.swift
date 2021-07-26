//
//  PostViewController.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import UIKit

class PostViewController: UIViewController {
     let model: PostModel

    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colors : [UIColor] = [.red, .green,.black,.orange,.blue,.white,.systemPink]
        view.backgroundColor = colors.randomElement()
    }
    
    
    

   

}
