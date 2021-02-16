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

class ViewController: UIViewController {
    
    // Create search bar
    let searchBar:UISearchBar = UISearchBar()
    
    var topInset:CGFloat = 0.0
    
    let profileContainer:UIView = UIView()
    
    let scrollView:UIScrollView = UIScrollView()
    
    let contentView:UIView = UIView()
    
    override func viewDidLayoutSubviews() {
        // Get main window for save view
        let window = UIApplication.shared.windows[0]
        topInset = window.safeAreaInsets.top
        
        // Set margin from safe area for profile container
        profileContainer.frame = CGRect(x: self.view.frame.maxX - 150, y: topInset + 10, width: 130, height: 35)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar since it's adding wrong space on app start
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Change background color of view
        self.view.backgroundColor = UIColor(hexString: "#131212")
        
        // Add tap gesture to view
        let viewClickTapGesture = UITapGestureRecognizer()
        scrollView.addGestureRecognizer(viewClickTapGesture)
        viewClickTapGesture.addTarget(self, action: #selector(viewClick))
        
        // Get main window for save view
        let window = UIApplication.shared.windows[0]
        topInset = window.safeAreaInsets.top

        // Create profile container
        profileContainer.frame = CGRect(x: self.view.frame.maxX - 150, y: topInset + 10, width: 130, height: 35)

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
        
        // Add profile container to parent view
        self.view.addSubview(profileContainer)
        
        // Bring profileContainer on top so the other content scrolls behind it
        profileContainer.layer.zPosition = 1
        
        // Create UIScrollView
        setupScrollView()
        
        // Create chayns label
        let chaynsLabel:UILabel = UILabel()
        chaynsLabel.text = "chayns"
        chaynsLabel.textAlignment = .center
        chaynsLabel.textColor = .white
        chaynsLabel.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        chaynsLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        // chaynsLabel.layer.zPosition = -1
        
        // Add chayns label to scroll content view
        contentView.addSubview(chaynsLabel)

        // Configure searchbar
        searchBar.barStyle = UIBarStyle.black
        searchBar.placeholder = "Finden"
        searchBar.frame = CGRect(x: self.view.frame.minX + 25, y: chaynsLabel.frame.maxY + 40, width: self.view.frame.width - 50, height: 40)
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.borderColor = UIColor.gray.cgColor
        searchBar.layer.cornerRadius = 3
        searchBar.backgroundImage = UIImage() /* remove shadow borders */
        searchBar.backgroundColor = .black
        searchBar.tintColor = .systemBlue /* cursor color */
        
        // Accessing the tex tfield inside the search bar to change the text color
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        
        // Add search bar to scroll content view
        contentView.addSubview(searchBar)

        // Create sites container (still needs to be responsive)
        let sitesContainer:UIView = UIView()
        sitesContainer.frame = CGRect(x: self.view.frame.minX + 45, y: searchBar.frame.maxY + 30, width: searchBar.frame.size.width - 40, height: self.view.frame.size.height)

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
                marginTop += 100
                marginBetween = 0
            } else {
                // Update margin | 60px (the width of the container + 20px as margin between the boxes)
                marginBetween += 80
            }
        }
        
        // Add sites container to scroll content view
        contentView.addSubview(sitesContainer)
    }
    
    @objc func viewClick() {
        searchBar.endEditing(true) /* close keyboard  */
        print("view clicked")
    }
    
    @objc func siteClick() {
        print("clicked")
        let webView = WebViewController()
        webView.topInset = topInset
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    func setupScrollView() {
        
        scrollView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.contentSize.height = self.view.frame.size.height + 50
        scrollView.showsVerticalScrollIndicator = false
        
        print("profileContainer", profileContainer.frame.height)
        
        contentView.frame = CGRect(x: self.view.frame.minX, y: profileContainer.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height + 10)
        
        // Add scroll view to main view
        self.view.addSubview(scrollView)
        
        // Add content to scrollview
        scrollView.addSubview(contentView)
    }
}
