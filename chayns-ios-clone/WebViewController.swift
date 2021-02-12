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
    
    var topInset:CGFloat!
    // Create overlay for web view
    let overlay:UIView = UIView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Change status bar color
        let tabBar:TabBar = TabBar()
        tabBar.changeStatusBarStyle(style: UIBarStyle.default)

        // Configure WebView
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: CGRect(x: self.view.frame.minX, y: topInset, width: self.view.frame.width, height: self.view.frame.height), configuration: config)
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never

        // Set overlay for web view
        overlay.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: topInset)
        overlay.backgroundColor = .white
        self.view.addSubview(overlay)

        let siteRequest = URLRequest(url: URL(string: "https://labs.tobit.com")!)
        webView.load(siteRequest)
        self.view.addSubview(webView)
    }
}
