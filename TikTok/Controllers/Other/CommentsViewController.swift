//
//  CommentsViewController.swift
//  TikTok
//
//  Created by mai ng on 7/27/21.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}


class CommentsViewController: UIViewController, UITableViewDelegate {

    private let post: PostModel
    
    weak var delegate: CommentsViewControllerDelegate?
    private var comments = [PostComment]()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
        
    }()
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        view.backgroundColor = .white
        fetchPostComments()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 60 , y: 10, width: 30, height: 30)
        
        tableView.frame = CGRect(x: 0,
                                 y: closeButton.bottom,
                                 width: view.width,
                                 height: view.width - closeButton.bottom)

    }
    
    
    @objc private func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }
    func fetchPostComments() {
        self.comments = PostComment.mockComments()
               }

}


extension CommentsViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = comment.text
        return cell
    }
    
    
}
