//
//  NotificationsViewController.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    let noNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text  = "No Notifications"
        label.isHidden = true
        label.textAlignment = .center
    
        return label
        
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(
            NotificationsUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier)
        
        table.register(
            NotificationPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationPostLikeTableViewCell.identifier)
        
        table.register(
            NotificationsPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier)
        
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return  spinner
    }()
    
    var notifications = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(tableView)
        view.addSubview(noNotificationLabel)
        view.addSubview(spinner)
        
        tableView.delegate = self
        tableView.dataSource = self

        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = control
        
        
  
        fetchNotifiacations()
    }
    
        @objc func didPullToRefresh(_ sender: UIRefreshControl) {
            sender.beginRefreshing()
            DatabaseManager.shared.getNotifications { [weak self] notifications in
                DispatchQueue.main.async {
                    self?.notifications = notifications
                    self?.tableView.reloadData()
    
                    sender.endRefreshing()
                }
    
            }
        }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationLabel.center = view.center
        
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
   func fetchNotifiacations(){
    DatabaseManager.shared.getNotifications {[weak self] notifications in
        DispatchQueue.main.async {
            self?.spinner.stopAnimating()
            self?.spinner.isHidden = true
            self?.notifications = notifications
            self?.updateUI()
        }
      }
   }
    
    func updateUI() {
        if notifications.isEmpty {
            noNotificationLabel.isHidden = false
            tableView.isHidden = true
        }else {
            noNotificationLabel.isHidden = true
            tableView.isHidden = false
            
        }
        tableView.reloadData()
    }

}


extension NotificationsViewController:UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        
        switch model.type {
        
        case .postLike(postName: let postName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationPostLikeTableViewCell.identifier, for: indexPath) as? NotificationPostLikeTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.delegate = self
            cell.configure(with: postName,model: model)
            return cell

        case .userFolow(userName: let userName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsUserFollowTableViewCell.identifier, for: indexPath) as? NotificationsUserFollowTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.delegate = self
            cell.configure(with: userName,model: model)
            return cell
            
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsPostCommentTableViewCell.identifier, for: indexPath) as? NotificationsPostCommentTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.delegate = self
            cell.configure(with: postName,model: model)
            return cell
            
        }
        
    }
  
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard  editingStyle == .delete  else {
            return
        }
        let model = notifications[indexPath.row]
        model.isHidden = true
        self.notifications = self.notifications.filter({$0.isHidden == false})
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self] success in
            DispatchQueue.main.async {
            if success {
                    self?.notifications = self?.notifications.filter({$0.isHidden == false}) ?? []
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
                
            }
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
  
}

extension NotificationsViewController: NotificationsUserFollowTableViewCellDelegate {
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapFolowFor username: String) {
        
        DatabaseManager.shared.follow(username: username) { success in
            if !success {
                print("something failed")
            }
        }
    }
    
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapAvatarFor username: String) {
        let vc = ProfileViewController(user: User(username: username,
                                                  profilePictureURL: nil,
                                                  identifier: "123"))
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension NotificationsViewController: NotificationPostLikeTableViewCellDelegate {
    func notificationPostLikeTableViewCell(_ cell: NotificationPostLikeTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
        
    }
    
    
}
extension NotificationsViewController: NotificationsPostCommentTableViewCellDelegate {
    func notificationsPostCommentTableViewCell(_ cell: NotificationsPostCommentTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
        
    }
}

extension NotificationsViewController {
    func openPost(with ID: String) {
        // resolve the post model from database
        let vc = PostViewController(model: PostModel(identifier: ID))
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
}
