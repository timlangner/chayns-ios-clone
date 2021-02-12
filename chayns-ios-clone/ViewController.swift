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
    
    var topInset:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color of view
        self.view.backgroundColor = UIColor(hexString: "#131212")
        
        // Add tap gesture to view
        let viewClickTapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(viewClickTapGesture)
        viewClickTapGesture.addTarget(self, action: #selector(viewClick))
        
        // Get main window for save view
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        topInset = keyWindow!.safeAreaInsets.top
        
        // Create profile container
        let profileContainer:UIView = UIView()
        profileContainer.frame = CGRect(x: self.view.frame.maxX - 150, y: topInset + 10, width: 130, height: 35)

        // Create profile name
        let profileName:UILabel = UILabel()
        profileName.text = "Tim Langner"
        profileName.textColor = .white
        profileName.font = UIFont.systemFont(ofSize: 14)
        profileName.frame = CGRect(x: 0, y: 0, width: profileContainer.frame.width, height: profileContainer.frame.height)

        // Create ImageView for the profile picture
        let profilePictureView:UIImageView = UIImageView()
        let profilePicture = UIImage(named: "profile_picture")
        profilePictureView.layer.cornerRadius = 20
        profilePictureView.clipsToBounds = true
        profilePictureView.image = profilePicture
        profilePictureView.frame = CGRect(x: profileContainer.frame.width - 35, y: 0, width: 35, height: 35)
        // Add profile name & picture to profile container
        profileContainer.addSubview(profileName)
        profileContainer.addSubview(profilePictureView)
        
        // Add profile container to parent view
        self.view.addSubview(profileContainer)
        
        // Create chayns label
        let chaynsLabel:UILabel = UILabel()
        chaynsLabel.text = "chayns"
        chaynsLabel.textAlignment = .center
        chaynsLabel.textColor = .white
        chaynsLabel.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        chaynsLabel.frame = CGRect(x: 0, y: profileContainer.frame.maxY + 65, width: self.view.frame.width, height: 50)
        
        // Add chayns label to parent view
        self.view.addSubview(chaynsLabel)

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
        
        // Accessing the textfield inside the search bar to change the text color
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        
        // Add search bar to parent view
        self.view.addSubview(searchBar)

        // Create sites container
        let sitesContainer:UIView = UIView()
        sitesContainer.frame = CGRect(x: self.view.frame.minX + 45, y: searchBar.frame.maxY + 30, width: searchBar.frame.size.width - 40, height: 475)

        var marginBetween = 0
        var marginTop = 0

        for i in 0...15 {
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
        
        // Add sites container to parent view
        self.view.addSubview(sitesContainer)
        
        // QR scanner above tab bar
        let scanner:UIView = UIView()
        scanner.backgroundColor = .systemGray6
        scanner.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY - 109, width: self.view.frame.width, height: 25)
        self.view.addSubview(scanner)
        
        // QR scanner grabber
        let scannerGrab:UIView = UIView()
        scannerGrab.backgroundColor = .gray
        scannerGrab.frame = CGRect(x: scanner.frame.maxX / 2 - 21.75, y: 12, width: 42.5, height: 4)
        scannerGrab.layer.cornerRadius = 2
        scannerGrab.clipsToBounds = true
        scanner.addSubview(scannerGrab)
    }
    
    @objc func viewClick() {
        searchBar.endEditing(true) /* close keyboard  */
    }
    
    @objc func siteClick() {
        let webView = WebViewController()
        webView.topInset = topInset
        self.navigationController?.pushViewController(webView, animated: true)
    }
}
