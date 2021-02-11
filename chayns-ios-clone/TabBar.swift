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
                                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }

    // Generate navigation controller for the tab bar with title, icon and icon title
    func setupVCs() {
        viewControllers = [
            createNavController(for: ViewController(), title: NSLocalizedString("", comment: ""), image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: ViewController(), title: NSLocalizedString("Eingang", comment: ""), image: UIImage(systemName: "envelope")!),
            createNavController(for: ViewController(), title: NSLocalizedString("Intercom", comment: ""), image: UIImage(systemName: "bubble.left.and.bubble.right")!),
            createNavController(for: ViewController(), title: NSLocalizedString("Wallet", comment: ""), image: UIImage(systemName: "folder")!),
            createNavController(for: ViewController(), title: NSLocalizedString("Mehr", comment: ""), image: UIImage(systemName: "ellipsis")!)
        ]
    }
}
