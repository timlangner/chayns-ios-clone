//
//  TabBar.swift
//  chayns-ios-clone
//
//  Created by Langner, Tim on 11.02.21.
//

import UIKit
import Foundation

class TabBar: UITabBarController, UITabBarControllerDelegate {
    
    var test: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = .systemBackground /* color scheme */
        tabBar.tintColor = .label
        
        setupVCs() /* Configure Tab Items */
        
        self.delegate = self
    }
    
    // Create navigation controller
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      badgeValue: String?,
                                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.badgeValue = badgeValue
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }

    // Configure tabbar items
    func setupVCs() {
        viewControllers = [
            createNavController(for: ViewController(), title: NSLocalizedString("", comment: ""), badgeValue: nil, image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: UIViewController(), title: NSLocalizedString("Eingang", comment: ""), badgeValue: "3", image: UIImage(systemName: "envelope")!),
            createNavController(for: UIViewController(), title: NSLocalizedString("Intercom", comment: ""), badgeValue: "4", image: UIImage(systemName: "bubble.left.and.bubble.right")!),
            createNavController(for: UIViewController(), title: NSLocalizedString("Wallet", comment: ""), badgeValue: nil, image: UIImage(systemName: "folder")!),
            createNavController(for: UIViewController(), title: NSLocalizedString("Mehr", comment: ""), badgeValue: nil, image: UIImage(systemName: "ellipsis")!)
        ]
    }
    
    // React to click events
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // Get index of clicked tab
        guard let index = tabBarController.viewControllers?.firstIndex(where: {$0 === viewController}) else {
            return false
        }
        
        // Check which tab is selected
        if index == 0 {
            print("First tab selected")
        }
        
        return true
    }
    
    // Change Statusbar color
    func changeStatusBarStyle(style: UIBarStyle) {
        print("Change color")
        self.navigationController?.navigationBar.barStyle = style
        UITabBar.appearance().barTintColor = .systemBackground /* override color scheme */
    }
}
