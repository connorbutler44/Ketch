//
//  ReviewCell.swift
//  Ketch
//
//  Created by Connor Butler on 4/12/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase

class ReviewCell: UITableViewCell{
    var review: review? {
        didSet{
            imageView?.image = UIImage(named: "loading.gif")
            setupNameAndProfileImage()
            
            detailTextLabel?.text = review?.message
            let str = (review?.rating)! + "/5"
            timeLabel.text = str
            
        }
    }
    private func setupNameAndProfileImage(){
        let itemID = review?.forItem
        let ref = FIRDatabase.database().reference().child("items").child((itemID)!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let item = dictionary["title"] as? String
                self.textLabel?.text = item
            }
        }, withCancel: nil)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        timeLabel.font = timeLabel.font?.withSize(32)
        
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
