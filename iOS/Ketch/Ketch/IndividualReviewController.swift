//
//  IndividualReviewController.swift
//  Ketch
//
//  Created by Connor Butler on 2/17/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//
//
//  This view controller shows an individual item from the ItemListController with it's corresponding data from Firebase

import UIKit
import Firebase

class IndividualReviewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDesc: UITextView!
    @IBOutlet weak var descField: UITextView!
    
    var review: review? {
        didSet{
            
        }
    }
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputComponents()
        self.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(red: 1/255, green: 112/255, blue: 111/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        let image = UIImage(named: "back")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleBack))

        
    }
    
   
    func handleBack(){
        //navigationController?.popViewController(messageController, animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
 
    
    func setupInputComponents(){
        let navigationBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height
        let tabBarHeight: CGFloat = (self.tabBarController?.tabBar.frame.height)! * -1
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: tabBarHeight).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        let title = UILabel()
        let ref = FIRDatabase.database().reference().child("items").child((review?.forItem)!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let item = dictionary["title"] as? String
                title.text = item
            }
        }, withCancel: nil)
        
        title.text = review?.forItem
        title.font = title.font.withSize(24)
  
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor.darkGray
        title.backgroundColor = UIColor.white
        
        containerView.addSubview(title)
        
        title.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        title.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight + 12).isActive = true
        title.heightAnchor.constraint(equalToConstant: 34).isActive = true
        title.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -124).isActive = true
        
        
        let priceLabel = UILabel()
        let str = (review?.rating)! + "/5"
        priceLabel.text = str
        priceLabel.font = title.font.withSize(24)
 
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = UIColor.darkGray
        priceLabel.backgroundColor = UIColor.white
        priceLabel.textAlignment = NSTextAlignment.right
        
        containerView.addSubview(priceLabel)
        
        priceLabel.leftAnchor.constraint(equalTo: title.rightAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight + 12).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let titleSeparator = UIView()
        titleSeparator.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        titleSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleSeparator)
        
        titleSeparator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        titleSeparator.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
        titleSeparator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        titleSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let reviewDesc = UITextView()
        reviewDesc.translatesAutoresizingMaskIntoConstraints = false
        reviewDesc.textColor = UIColor.darkGray
        reviewDesc.backgroundColor = UIColor.white
        reviewDesc.text = review?.message
        reviewDesc.font = reviewDesc.font?.withSize(20)
        
        containerView.addSubview(reviewDesc)
        
        reviewDesc.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        reviewDesc.topAnchor.constraint(equalTo: titleSeparator.bottomAnchor, constant: 12).isActive = true
        reviewDesc.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        reviewDesc.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        
        
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

