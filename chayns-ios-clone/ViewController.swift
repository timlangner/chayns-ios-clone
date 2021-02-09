//
//  ViewController.swift
//  chayns-ios-clone
//
//  Created by Langner, Tim on 08.02.21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create profile container
        let profileContainer:UIView = UIView()
        profileContainer.frame = CGRect(x: 300, y: 30, width: 300, height: 60)
        profileContainer.backgroundColor = UIColor.red
        
        // Create profile name
        let profileName:UILabel = UILabel()
        profileName.text = "Tim Langner"
        profileName.textColor = .white
        profileName.font = UIFont.systemFont(ofSize: 15)
        
        // Create ImageView for the profile picture
        let profilePictureView:UIImageView = UIImageView();
        let profilePicture = UIImage(named: "profile_picture")
        profilePictureView.frame.size.height = 35
        profilePictureView.frame.size.width = 35
        profilePictureView.image = profilePicture
        profilePictureView.layer.cornerRadius = 20
        
        // Add profile name & picture to profile container
        profileContainer.addSubview(profileName)
        profileContainer.addSubview(profilePictureView)
        
        // Create chayns label
        let chaynsLabel:UILabel = UILabel()
        chaynsLabel.text = "chayns"
        chaynsLabel.textColor = .white
        chaynsLabel.font = UIFont.systemFont(ofSize: 45)
        
        // Create search bar
        let searchBar:UISearchBar = UISearchBar()
        searchBar.barStyle = UIBarStyle.black
        
        // Create sites container
        let sitesContainer:UIView = UIView()
        
        // Set position for sites container
        sitesContainer.frame = CGRect(x: 20, y: 256, width: self.view.frame.width - 20 - 20 /*leftMargin-rightMargin*/, height: self.view.frame.height - (searchBar.frame.maxY) - self.view.frame.maxY)
        
        sitesContainer.backgroundColor = .blue
        
        print(sitesContainer.frame)
        
        
        let campusIcon = UIImage(named: "labs-icon")
        
        for _ in 0...7 {
            // Create a new UIImageView as a container for the image
            let imageView:UIImageView = UIImageView()
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.frame.size.height = 60
            imageView.frame.size.width = 60
            imageView.center = CGPoint(x: 10, y: 10) // self.sitesContainer.center
            imageView.image = campusIcon
            
            // Add image to the sites container
            sitesContainer.addSubview(imageView)
        }
    }
}

