//
//  ProfileViewController.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import UIKit

class ProfileViewController: UIViewController {
    let user: User
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero
                                          , collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator  = false
        collection.register(ProfileHeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader ,
                            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    // MARK - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource =  self
        
        let username = UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "Me"
        if title == username  {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action:#selector(didTapSettings))
        }
        
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        
    return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Open Post
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.width - 12)/3
        return CGSize(width: width, height: width * 1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind  == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.delegate = self
        let viewModel = ProfileHeaderViewModel(
            avatarImageURL: nil,
            followerCount: 120,
            followingCount: 200,
            isFollowing: true)
        header.configure(with: viewModel)
        return header
              
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}
extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate{
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
           return
        }
        if self.user.username == currentUsername {
            // Edit Profile
        } else {
            // Follow or unfollow current users profile that we are viewing
        }
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    
}
