//
//  TabBar.swift
//  chayns-ios-clone
//
//  Created by Langner, Tim on 11.02.21.
//

import UIKit
import Foundation

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      badgeValue: String?,
                                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.badgeValue = badgeValue
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }

    // Generate navigation controller for the tab bar with title, icon and icon title
    func setupVCs() {
        viewControllers = [
            createNavController(for: ViewController(), title: NSLocalizedString("", comment: ""), badgeValue: nil, image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: ViewController(), title: NSLocalizedString("Eingang", comment: ""), badgeValue: "3", image: UIImage(systemName: "envelope")!),
            createNavController(for: ViewController(), title: NSLocalizedString("Intercom", comment: ""), badgeValue: "4", image: UIImage(systemName: "bubble.left.and.bubble.right")!),
            createNavController(for: ViewController(), title: NSLocalizedString("Wallet", comment: ""), badgeValue: nil, image: UIImage(systemName: "folder")!),
            createNavController(for: ViewController(), title: NSLocalizedString("Mehr", comment: ""), badgeValue: nil, image: UIImage(systemName: "ellipsis")!)
        ]
    }
}
