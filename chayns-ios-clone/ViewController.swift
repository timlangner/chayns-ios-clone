//
//  ViewController.swift
//  chayns-ios-clone
//
//  Created by Langner, Tim on 08.02.21.
//

import UIKit
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color of view
        self.view.backgroundColor = UIColor(hexString: "#131212")
        
        // Create profile container
        let profileContainer:UIView = UIView()
        profileContainer.frame = CGRect(x: self.view.frame.maxX - 150, y: 50, width: 130, height: 35)

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
        chaynsLabel.frame = CGRect(x: 0, y: profileContainer.frame.maxY + 50, width: self.view.frame.width, height: 50)
        
        // Add chayns label to parent view
        self.view.addSubview(chaynsLabel)

        // Create search bar
        let searchBar:UISearchBar = UISearchBar()
        searchBar.barStyle = UIBarStyle.black
        searchBar.placeholder = "Finden"
        searchBar.frame = CGRect(x: self.view.frame.minX + 25, y: chaynsLabel.frame.maxY + 40, width: self.view.frame.width - 50, height: 40)
        
        // Add search bar to parent view
        self.view.addSubview(searchBar)

        // Create sites container
        let sitesContainer:UIView = UIView()
        sitesContainer.frame = CGRect(x: self.view.frame.minX + 45, y: searchBar.frame.maxY + 30, width: searchBar.frame.size.width - 40, height: 450)
        sitesContainer.layer.borderWidth = 1
        sitesContainer.layer.borderColor = UIColor.white.cgColor

        let campusIcon = UIImage(named: "labs-icon")

        for _ in 0...7 {
            // Create a new UIImageView as a container for the image
            let imageView:UIImageView = UIImageView()
            imageView.frame = CGRect(x: 55, y: 30, width: 60, height: 60)
            imageView.image = campusIcon

            // Add image to the sites container
            sitesContainer.addSubview(imageView)
        }
        
        // Add sites container to parent view
        self.view.addSubview(sitesContainer)
    }
}

