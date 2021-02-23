//
//  ViewController.swift
//  chayns-ios-clone
//
//  Created by Langner, Tim on 08.02.21.
//

import UIKit
import WebKit
import Foundation

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var safeAreaInsets:UIEdgeInsets!
    
    var currentSpace:Int = 25
    
    let searchBar:UISearchBar = UISearchBar()
    
    let qrButton = UIButton()
    
    let blurContainer:UIView = UIView()
    
    let profileContainer:UIView = UIView()
    
    let chaynsLabel:UILabel = UILabel()
    
    let sitesContainer:UIView = UIView()
    
    let newSitesContainer:UIView = UIView()
    
    let scrollView:UIScrollView = UIScrollView()
    
    let contentView:UIView = UIView()
    
    var rootScrollPosition:CGFloat = 0.0
    
    var scrollEventCount:Int = 0
    
    var scannerMinY:CGFloat = 0.0
    
    let blurEffect = UIBlurEffect(style: .dark)
    
    let blurredEffectView = UIVisualEffectView()
    
    var isAnimated = false
    
    override func viewDidLayoutSubviews() {
        // Get main window for save view
        let window = UIApplication.shared.windows[0]
        safeAreaInsets = window.safeAreaInsets
        
        // Set margin from safe area for profile container
        profileContainer.frame = CGRect(x: self.view.frame.maxX - 150, y: safeAreaInsets.top + 10, width: 130, height: 35)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyDeviceOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In order to use scrollview delegate methods
        self.scrollView.delegate = self
        
        // Hide navigation bar since it's adding wrong space on app start
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Change background color
        self.view.backgroundColor = UIColor(hexString: "#131212")
        
        // Add tap gesture to view to disable keyboard when clicking out of the searchbar
        let viewClickTapGesture = UITapGestureRecognizer()
        scrollView.addGestureRecognizer(viewClickTapGesture)
        viewClickTapGesture.addTarget(self, action: #selector(viewClick))
        
        // Get main window for save view
        let window = UIApplication.shared.windows[0]
        safeAreaInsets = window.safeAreaInsets

        // Create profile container
        profileContainer.frame = CGRect(x: self.view.frame.maxX - 150, y: safeAreaInsets.top + 10, width: 130, height: 35)
        // Create profile name
        let profileName:UILabel = UILabel()
        profileName.text = "Tim Langner"
        profileName.textColor = .white
        profileName.font = UIFont.systemFont(ofSize: 15)
        profileName.frame = CGRect(x: 0, y: 0, width: profileContainer.frame.width, height: profileContainer.frame.height)

        // Create ImageView for the profile picture
        let profilePictureView:UIImageView = UIImageView()
        let profilePicture = UIImage(named: "profile_picture")
        profilePictureView.layer.cornerRadius = 17.5
        profilePictureView.clipsToBounds = true
        profilePictureView.image = profilePicture
        profilePictureView.frame = CGRect(x: profileContainer.frame.width - 35, y: 0, width: 35, height: 35)
        
        // Add profile name & picture to profile container
        profileContainer.addSubview(profileName)
        profileContainer.addSubview(profilePictureView)
        
        // Configure blur container
        blurContainer.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: safeAreaInsets.top + (profileContainer.frame.size.height + 25))
        blurContainer.layer.zPosition = 1
        blurredEffectView.frame = blurContainer.bounds
        blurredEffectView.effect = blurEffect
        
        // Add profile to blur container
        blurContainer.addSubview(profileContainer)
        
        // Add blur container to parent view
        self.view.addSubview(blurContainer)
        
        // Bring profileContainer on top so the other content scrolls behind it
        profileContainer.layer.zPosition = 2
        
        // Configure chayns label
        chaynsLabel.text = "chayns"
        chaynsLabel.textAlignment = .center
        chaynsLabel.textColor = .white
        chaynsLabel.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        chaynsLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        // Add chayns label to scroll content view
        contentView.addSubview(chaynsLabel)

        // Configure searchbar
        searchBar.barStyle = UIBarStyle.black
        searchBar.placeholder = "Finden"
        searchBar.frame = CGRect(x: self.view.frame.minX + 25, y: chaynsLabel.frame.maxY + 40, width: self.view.frame.width - 50, height: 40)
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.borderColor = UIColor.darkGray.cgColor
        searchBar.layer.cornerRadius = 3
        searchBar.backgroundImage = UIImage() /* remove shadow borders */
        searchBar.backgroundColor = .black
        searchBar.tintColor = .systemBlue /* cursor color */
        
        // Accessing the textfield inside the search bar to change the text color
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        
        // Add search bar to scroll content view
        contentView.addSubview(searchBar)
        
        // Scanner button
        qrButton.frame = CGRect(x: searchBar.frame.maxX - searchBar.frame.height, y: searchBar.frame.minY, width: searchBar.frame.height, height: searchBar.frame.height)
        qrButton.backgroundColor = .white
        qrButton.roundCorners(corners: [.topRight, .bottomRight], radius: 3)
        
        let qrIcon = UIImageView()
        qrIcon.image = UIImage(named: "qr-icon")
        qrIcon.frame = CGRect(x: 0, y: 0, width: qrButton.frame.width, height: qrButton.frame.height)
        qrButton.addSubview(qrIcon)
        contentView.addSubview(qrButton)

        // Configure sites container
        sitesContainer.frame = CGRect(x: self.view.frame.minX + (self.view.frame.size.width - 315) / 2, y: searchBar.frame.maxY + 30, width: 315, height: 750)
        
        var marginBetween = 0
        var marginTop = 0
        
        for i in 0...23 {
            let icon = UIImage(named: "icon\(i + 1)")
            
            // Create new container for the site icon & name
            let siteContainer:UIView = UIView()
            siteContainer.frame = CGRect(x: marginBetween, y: marginTop, width: 60, height: 80)
            
            // Create a new UIImageView as a container for the image
            let imageView:UIImageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            imageView.image = icon
            
            // Create label for the site name
            let siteName:UILabel = UILabel()
            siteName.text = "Labs"
            siteName.font = UIFont.systemFont(ofSize: 11)
            siteName.textAlignment = .center
            siteName.textColor = .white
            siteName.frame = CGRect(x: 0, y: imageView.frame.maxY, width: imageView.frame.width, height: 25)

            // Add image and label to the site container
            siteContainer.addSubview(imageView)
            siteContainer.addSubview(siteName)
            
            // Add tap gesture to site container
            let siteClickTapGesture = UITapGestureRecognizer()
            siteContainer.addGestureRecognizer(siteClickTapGesture)
            siteClickTapGesture.addTarget(self, action: #selector(siteClick))
            
            // Add site to sites container
            sitesContainer.addSubview(siteContainer)
            
            // Check if a row has 4 site containers and if so update the top margin & reset the horizontally margin
            if ((i + 1) % 4 == 0) {
                marginTop += 120 /* 120 pixels space between icons vertically */
                marginBetween = 0
            } else {
                // Update margin | 60px (the width of the container + 25px as margin between the boxes)
                marginBetween += (60 + currentSpace)
            }
        }
        
        // Add sites container to scroll content view
        contentView.addSubview(sitesContainer)
        
        // Create UIScrollView
        setupScrollView()
    }
    
    @objc func viewClick() {
        searchBar.endEditing(true) /* close keyboard  */
    }
    
    @objc func siteClick() {
        let webView = WebViewController()
        webView.safeAreaInsets = safeAreaInsets
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    func setupScrollView() {
        scrollView.frame = self.view.frame
        contentView.frame = CGRect(x: self.view.frame.minX, y: profileContainer.frame.maxY + 20, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        // Configure content size height which needs to be as high as all the content is + extra margin so its above the tabbar
        scrollView.contentSize.height = sitesContainer.frame.maxY + (self.view.frame.maxY - scannerMinY)
        
        // Disable vertical scroll bar
        scrollView.showsVerticalScrollIndicator = false
        
        // Add scroll view to main view
        self.view.addSubview(scrollView)
        
        // Add content to scrollview
        scrollView.addSubview(contentView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check scroll position
        scrollEventCount += 1
        
        // Only set rootScrollPosition once
        if (scrollEventCount == 1) {
            rootScrollPosition = scrollView.bounds.minY
        }
        
        if (scrollView.bounds.minY <= rootScrollPosition) {
            blurFadeOut()
        } else {
            if (!isAnimated) {
                blurredEffectView.removeFromSuperview()
                blurContainer.addSubview(blurredEffectView)
                
                blurredEffectView.alpha = 0
                blurFadeIn()
                isAnimated = true
            }
            blurredEffectView.removeFromSuperview()
            blurContainer.addSubview(blurredEffectView)
        }
    }
    
    func blurFadeIn() {
        UIView.animate(withDuration: 0.2, animations: {
            self.blurredEffectView.alpha = 1
        })
    }
    
    func blurFadeOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.blurredEffectView.alpha = 0
        }, completion: { finished in
            self.isAnimated = false
        })
    }
    
    func determineMyDeviceOrientation()
    {
        if UIDevice.current.orientation.isLandscape {
            print("Device is in landscape mode", contentView.frame)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.1 seconds delay
                print("currentView", self.view.frame)
                
                // Reload view
                self.viewDidLoad()
                
                // Remove old sites container
                self.sitesContainer.removeFromSuperview()
                
                var marginBetween = 0
                var marginTop = 0
                
                for i in 0...23 {
                    let icon = UIImage(named: "icon\(i + 1)")
                    
                    // Create new container for the site icon & name
                    let siteContainer:UIView = UIView()
                    siteContainer.frame = CGRect(x: marginBetween, y: marginTop, width: 60, height: 80)
                    
                    // Create a new UIImageView as a container for the image
                    let imageView:UIImageView = UIImageView()
                    imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                    imageView.image = icon
                    
                    // Create label for the site name
                    let siteName:UILabel = UILabel()
                    siteName.text = "Labs"
                    siteName.font = UIFont.systemFont(ofSize: 11)
                    siteName.textAlignment = .center
                    siteName.textColor = .white
                    siteName.frame = CGRect(x: 0, y: imageView.frame.maxY, width: imageView.frame.width, height: 25)

                    // Add image and label to the site container
                    siteContainer.addSubview(imageView)
                    siteContainer.addSubview(siteName)
                    
                    // Add tap gesture to site container
                    let siteClickTapGesture = UITapGestureRecognizer()
                    siteContainer.addGestureRecognizer(siteClickTapGesture)
                    siteClickTapGesture.addTarget(self, action: #selector(self.siteClick))
                    
                    // Add site to sites container
                    self.newSitesContainer.addSubview(siteContainer)
                    
                    // Check if a row has 4 site containers and if so update the top margin & reset the horizontally margin
                    if ((i + 1) % 4 == 0) {
                        marginTop += 120 /* 120 pixels space between icons vertically */
                        marginBetween = 0
                    } else {
                        // Update margin | 60px (the width of the container + 100px as margin between the boxes)
                        marginBetween += (60 + 100)
                    }
                }
                
                self.contentView.addSubview(self.newSitesContainer)
                
                // Wait until the view is loaded to modify existing elements
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 2 seconds delay
                    // Remove profile & bl
                    
                    // Remove profile & blur container
                    self.blurContainer.removeFromSuperview()
                    
                    // Resize searchbar
                    self.searchBar.frame = CGRect(x: self.view.frame.minX + 100, y: self.chaynsLabel.frame.maxY + 40, width: self.view.frame.width - 200, height: 40)
                    
                    // Reposition qr button
                    self.qrButton.frame = CGRect(x: self.searchBar.frame.maxX - self.searchBar.frame.height, y: self.searchBar.frame.minY, width: self.searchBar.frame.height, height: self.searchBar.frame.height)
                    
                    // Adjust sitesContainer width for bigger space between icons
                    self.newSitesContainer.frame = CGRect(x: self.searchBar.frame.minX + 50, y: self.searchBar.frame.maxY + 30, width: self.searchBar.frame.width - 100, height: 750)
                    
                    // Adjust scrollheight
                    self.scrollView.contentSize.height = self.newSitesContainer.frame.maxY + (self.view.frame.maxY - 360)
                }
            }
        } else {
            print("Device is in portrait mode", contentView.frame)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.1 seconds delay
                
                // Remove sites container for the landing orientation
                self.newSitesContainer.removeFromSuperview()
                
                // Reload view
                self.viewDidLoad()
                
                // Add profile & blur container
                self.view.addSubview(self.blurContainer)
                
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        determineMyDeviceOrientation()
    }
}
