//
//  WebViewController.swift
//  chayns-ios-clone
//
//  Created by Langner, Tim on 12.02.21.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    // Create Web View
    var webView : WKWebView!
    
    var safeAreaInsets:UIEdgeInsets!
    // Create overlay for web view
    let overlay:UIView = UIView()
    
    var notchPosition:String = ""
    
    let config:Config = Config()
    
    var token:String = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Get token
        token = config.getToken()
        
        if (safeAreaInsets.top > safeAreaInsets.bottom) {
            notchPosition = "top"
        } else {
            notchPosition = "side"
        }
        
        // Change status bar color
        let tabBar:TabBar = TabBar()
        tabBar.changeStatusBarStyle(style: UIBarStyle.default)

        // Configure WebView
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        // webView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never

        // Set overlay for web view
        if (notchPosition == "top") {
            webView = WKWebView(frame: CGRect(x: self.view.frame.minX, y: safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height - safeAreaInsets.top), configuration: config)
            overlay.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: safeAreaInsets.top)
        } else {
            print("landscape view")
            overlay.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: safeAreaInsets.left, height: self.view.frame.height)
            webView = WKWebView(frame: CGRect(x: self.view.frame.minX + self.overlay.frame.maxX, y: self.view.frame.minY, width: self.view.frame.width - safeAreaInsets.left, height: self.view.frame.height), configuration: config)
        }
        overlay.backgroundColor = .white
        self.view.addSubview(overlay)

        var siteRequest = URLRequest(url: URL(string: "https://labs.tobit.com")!)
        siteRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        webView.load(siteRequest)
        self.view.addSubview(webView)
    }
    
    func determineMyDeviceOrientation()
    {
        if UIDevice.current.orientation.isLandscape {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.1 seconds delay
                
                // Reassign webview frame & overlay
                self.webView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width - self.safeAreaInsets.left, height: self.view.frame.height)
                self.overlay.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.safeAreaInsets.left, height: self.view.frame.height)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.1 seconds delay
                // Reassign webview frame & overlay
                self.webView.frame = CGRect(x: self.view.frame.minX, y: self.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height - self.safeAreaInsets.top)
                self.overlay.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.safeAreaInsets.top)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        determineMyDeviceOrientation()
    }
}
