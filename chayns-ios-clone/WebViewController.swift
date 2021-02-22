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
    
    let token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsInZlciI6MSwia2lkIjoibXRqY21kYTQifQ.eyJqdGkiOiIyNDZhYzE2ZS05NWJhLTQ5MTktYWZjNS1jYmE3ZGU5NzIyMGEiLCJzdWIiOiIxMzItNDkyODIiLCJ0eXBlIjoxLCJleHAiOiIyMDIxLTAyLTI2VDA5OjExOjE4WiIsImlhdCI6IjIwMjEtMDItMjJUMDk6MTE6MThaIiwiTG9jYXRpb25JRCI6Mzc4LCJTaXRlSUQiOiI2MDAyMS0wODk4OSIsIklzQWRtaW4iOmZhbHNlLCJUb2JpdFVzZXJJRCI6MjEwNTkxMCwiUGVyc29uSUQiOiIxMzItNDkyODIiLCJGaXJzdE5hbWUiOiJUaW0iLCJMYXN0TmFtZSI6IkxhbmduZXIiLCJSb2xlcyI6WyJzd2l0Y2hfbG9jYXRpb24iXSwicHJvdiI6Mn0.tA5CveWEOMXAcIMkyz68pFU4VW7p9g7mOkecRe4S_Sld8S59bD2radxX3KMAUvkUv_L2CXpMTRELccrnlAz2GtimOQPrSzEa5q9OQ6sDYkzyVWvK5549ontPAgjd08Nbl-Hqo1bYqH11NW_KYKz8JihRBDBP5XWV45IwIAVU1G1qxbfHo5cxGTl3t-KBdesLhr5Ikji04uc_Nn54vzL-5WIYYzDU-mWtwc2qzJsUc-U4hLOx3BJYtINmYBM8Rc6qEIsnhoL8nvnqczz2kxVwBq1QQlTT2PQZ2PWw_M5AahHo9zM36_4HAV7sixFx9yyLa51X_RU-W-2BDFBvIxjzjQ"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
        
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
            webView = WKWebView(frame: CGRect(x: self.view.frame.minX, y: safeAreaInsets.top, width: self.view.frame.width - safeAreaInsets.left, height: self.view.frame.height), configuration: config)
            overlay.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: safeAreaInsets.left, height: self.view.frame.height)
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
