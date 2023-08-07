//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Monica Qiu on 8/6/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        
    }
    
    func setupTabBar() {
        
        // 3 tabs
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let libraryVC = LibraryViewController()
        
        // set nav titles & titles for the VCs
        homeVC.navigationItem.largeTitleDisplayMode = .always
        searchVC.navigationItem.largeTitleDisplayMode = .always
        libraryVC.navigationItem.largeTitleDisplayMode = .always
        
        // titles at top of page
        homeVC.title = "Browse"
        searchVC.title = "Search"
        libraryVC.title = "Library"
        
        // tab bar titles and icons
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        homeVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        homeVC.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 3)
        
        // set up navVCs for each tab
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        let libraryNavVC = UINavigationController(rootViewController: libraryVC)
        
        // set large titles for the nav VCs
        homeNavVC.navigationBar.prefersLargeTitles = true
        searchNavVC.navigationBar.prefersLargeTitles = true
        libraryNavVC.navigationBar.prefersLargeTitles = true
        
        setViewControllers([homeNavVC, searchNavVC, libraryNavVC], animated: false)
    }
    

}
