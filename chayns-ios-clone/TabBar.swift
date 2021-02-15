//
//  TabBar.swift
//  chayns-ios-clone
//
//  Created by Langner, Tim on 11.02.21.
//

import UIKit
import Foundation

class TabBar: UITabBarController, UITabBarControllerDelegate {
    var bottomSafeAreaInset:CGFloat = 0.0
    
    func getSafeAreaInsets() {
        // Get main window for save view
        let window = UIApplication.shared.windows[0]
        bottomSafeAreaInset = window.safeAreaInsets.bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getSafeAreaInsets()
        
        UITabBar.appearance().barTintColor = .systemBackground /* color scheme */
        tabBar.tintColor = .label
        
        setupVCs() /* Configure Tab Items */
        
        // QR scanner above tab bar
        let scanner:UIView = UIView()
        scanner.backgroundColor = .systemGray6
        
        // x: left border of the screen, y: minY of tabbar + height, width: width of screen, height: 25
        scanner.frame = CGRect(x: self.view.frame.minX, y: (tabBar.frame.minY - 25) - bottomSafeAreaInset , width: self.view.frame.width, height: 25)
        self.view.addSubview(scanner)
        
        // QR scanner grabber
        let scannerGrab:UIView = UIView()
        scannerGrab.backgroundColor = .gray
        scannerGrab.frame = CGRect(x: scanner.frame.maxX / 2 - 21.75, y: 12, width: 42.5, height: 4)
        scannerGrab.layer.cornerRadius = 2
        scannerGrab.clipsToBounds = true
        scanner.addSubview(scannerGrab)
        
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
        let iconConfig = UIImage.SymbolConfiguration(scale: .medium)
        viewControllers = [
            createNavController(for: ViewController(), title: NSLocalizedString("", comment: ""), badgeValue: nil, image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: UIViewController(), title: NSLocalizedString("Eingang", comment: ""), badgeValue: "3", image: UIImage(systemName: "envelope", withConfiguration: iconConfig)!),
            createNavController(for: UIViewController(), title: NSLocalizedString("Intercom", comment: ""), badgeValue: "4", image: UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: iconConfig)!),
            createNavController(for: UIViewController(), title: NSLocalizedString("Wallet", comment: ""), badgeValue: nil, image: UIImage(systemName: "folder", withConfiguration: iconConfig)!),
            createNavController(for: UIViewController(), title: NSLocalizedString("Mehr", comment: ""), badgeValue: nil, image: UIImage(systemName: "ellipsis", withConfiguration: iconConfig)!)
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
