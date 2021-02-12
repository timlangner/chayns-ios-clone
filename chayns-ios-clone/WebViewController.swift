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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure WebView
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: CGRect(x: self.view.frame.minX, y: topInset, width: self.view.frame.width, height: self.view.frame.height), configuration: config)
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        webView.scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)

        // Set overlay for web view
        overlay.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: topInset)
        overlay.backgroundColor = .white

        let siteRequest = URLRequest(url: URL(string: "https://labs.tobit.com")!)
        webView.load(siteRequest)
        self.view.addSubview(webView)
    }
}
