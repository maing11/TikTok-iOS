//
//  HomeViewController.swift
//  TikTok
//
//  Created by mai ng on 7/25/21.
//

import UIKit


class HomeViewController: UIViewController {
    
    private let  horizontialScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .red
        scrollView.isPagingEnabled = true
        return scrollView
        
    }()
    
    let forYouPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                navigationOrientation: .vertical,
                                                options: [:])
    let followingPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                navigationOrientation: .vertical,
                                                options: [:])
    
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(horizontialScrollView)
        
        setUpFeed()
        horizontialScrollView.contentOffset = CGPoint(x: view.width, y: 0)
    }

    // Where we go ahead and give the scroll view a frame horizontal scroll view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontialScrollView.frame = view.bounds
    }
    
    private func setUpFeed() {
        horizontialScrollView.contentSize = CGSize(width: view.width*2, height: view.height)
        setUpFollowingFeed()
        setUpForYouFeed()
      
        
    }
    
    func setUpFollowingFeed() {
        guard let model = followingPosts.first else {return }


        followingPageViewController.setViewControllers([PostViewController(model: model)],
                                            direction: .forward,
                                            animated: false,
                                            completion: nil)
        
        followingPageViewController.dataSource = self
        
        horizontialScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: horizontialScrollView.width,
                                             height: horizontialScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
        
    }
    
    func setUpForYouFeed() {
        guard let model = forYouPosts.first else {return }


        forYouPageViewController.setViewControllers([PostViewController(model: model)],
                                            direction: .forward,
                                            animated: false,
                                            completion: nil)
        
        forYouPageViewController.dataSource = self
        
        horizontialScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width,
                                             y: 0,
                                             width: horizontialScrollView.width,
                                             height: horizontialScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
    }

}


extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        guard let index = currentPosts.firstIndex(where: {$0.identifier == fromPost.identifier}) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        guard let index = currentPosts.firstIndex(where: {$0.identifier == fromPost.identifier}) else {
            return nil
        }
        
        // Need to be less than the last element in the actual array
        guard  index < (currentPosts.count - 1) else {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    var currentPosts: [PostModel] {
        if horizontialScrollView.contentOffset.x == 0 {
            // We on following page , which mean we all the way the left
            return followingPosts
        }
        
        return followingPosts
    }
    
}
