//
//  ItemCell.swift
//  Ketch
//
//  Created by Connor Butler on 3/24/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase

class ItemCell: UITableViewCell{
    var item: Items? {
        didSet{
            
            setupNameAndProfileImage()
            detailTextLabel?.text = item?.desc
            
            let str = "$" + (item?.price!)!
            timeLabel.text = str
            
        }
    }
    private func setupNameAndProfileImage(){
        var title = (item?.title!)!
        self.textLabel?.text = title

        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        textLabel?.frame = CGRect(x: 115, y: textLabel!.frame.origin.y, width: screenWidth - 125, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 115, y: detailTextLabel!.frame.origin.y, width: screenWidth - 125, height: detailTextLabel!.frame.height)
    }
    let profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        detailTextLabel?.numberOfLines = 3
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        timeLabel.adjustsFontSizeToFitWidth = true
        
       
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
