//
//  UserInfoController.swift
//  Ketch
//
//  Created by Connor Butler on 4/12/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase

class UserInfoController: UITableViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    var user: user? {
        didSet{

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(red: 1/255, green: 112/255, blue: 111/255, alpha: 1)
        let image = UIImage(named: "back")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleBack))
        setupInputComponents()
    }
    
    func handleBack(){
        //navigationController?.popViewController(messageController, animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
    let ratingSlider = UISlider()
    func setupInputComponents(){
        let navigationBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -navigationBarHeight).isActive = true
        
        let name = UILabel()
        name.text = user?.name
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.darkGray
        name.backgroundColor = UIColor.white
        name.font = name.font.withSize(24)
        
        containerView.addSubview(name)
        
        name.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight + 12).isActive = true
        name.heightAnchor.constraint(equalToConstant: 34).isActive = true
        name.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -124).isActive = true
        
        let titleSeparator = UIView()
        titleSeparator.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        titleSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleSeparator)
        
        titleSeparator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        titleSeparator.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 12).isActive = true
        titleSeparator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        titleSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let ratingLabel = UILabel()
        ratingLabel.text = "Rating"
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.textColor = UIColor.darkGray
        ratingLabel.backgroundColor = UIColor.white
        
        containerView.addSubview(ratingLabel)
        
        ratingLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        ratingLabel.topAnchor.constraint(equalTo: titleSeparator.bottomAnchor, constant: 12).isActive = true
        ratingLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        ratingLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        
        ratingSlider.maximumValue = 5
        ratingSlider.minimumValue = 0
        ratingSlider.setValue(0, animated: false)
        ratingSlider.translatesAutoresizingMaskIntoConstraints = false
        ratingSlider.isEnabled = false
        ratingSlider.minimumTrackTintColor = UIColor(red: 1/255, green: 112/255, blue: 111/255, alpha: 1)
        getUserRating()
        
        containerView.addSubview(ratingSlider)
        
        ratingSlider.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        ratingSlider.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12).isActive = true
        ratingSlider.heightAnchor.constraint(equalToConstant: 40).isActive = true
        ratingSlider.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -24).isActive = true
        
        let reviewLabel = UILabel()
        reviewLabel.text = "Reviews"
        reviewLabel.font = UIFont.boldSystemFont(ofSize: 20)
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.textColor = UIColor.darkGray
        reviewLabel.backgroundColor = UIColor.white
        
        containerView.addSubview(reviewLabel)
        
        reviewLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: ratingSlider.bottomAnchor, constant: 12).isActive = true
        reviewLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        reviewLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        let reviewContainer = UITableView()
        reviewContainer.translatesAutoresizingMaskIntoConstraints = false
        reviewContainer.backgroundColor = UIColor.darkGray
        
        containerView.addSubview(reviewContainer)
        
        reviewContainer.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        reviewContainer.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 12).isActive = true
        reviewContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12).isActive = true
        reviewContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -24).isActive = true
   
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var timer: Timer?

    
   
    
    func getUserRating(){
        let ref = FIRDatabase.database().reference().child("users").child((user?.id)!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let rating = dictionary["rating"] as? String
                let ratingFloat = Float(rating!)
                self.ratingSlider.setValue(ratingFloat!, animated: false)
            }
        }, withCancel: nil)
        
    }
    

}
