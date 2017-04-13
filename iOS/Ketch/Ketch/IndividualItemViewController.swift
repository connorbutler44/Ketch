//
//  NewViewController.swift
//  Ketch
//
//  Created by Connor Butler on 2/17/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//
//
//  This view controller shows an individual item from the ItemListController with it's corresponding data from Firebase

import UIKit
import Firebase

class IndividualItemViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDesc: UITextView!
    @IBOutlet weak var descField: UITextView!
    
    var item: Items? {
        didSet{
            print("item reference set")
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
        let uid = FIRAuth.auth()?.currentUser?.uid
        if(item?.seller == "meow"){
            let image = UIImage(named: "offers")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(offers))
        } else {
            let image = UIImage(named: "favoriteUnfilled")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(favorite))
            isFavorited()
            
        }
        
        
    }
    
    func isFavorited(){
        
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            guard let itemID = item?.itemID! else {
                return
            }
            let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
            let itemReference = ref.child("user-favorites").child(uid)
            itemReference.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let childSnapshot = snapshot.childSnapshot(forPath: (child as AnyObject).key)
                    if(childSnapshot.key == itemID){
                        let image = UIImage(named: "favoriteFilled")
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.unfavorite))
                    }
                }

            }, withCancel: nil)
            
            
            }
        
    }
    
    func offers(){
        //this will show the user current offers on this item
    }
    
    func unfavorite(){
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
        //values to be put into database
        let usersReference = ref.child("user-favorites").child(uid!).child((item?.itemID)!)
        usersReference.removeValue()
        let image = UIImage(named: "favoriteUnfilled")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.favorite))
        
        
    }
    
    func favorite(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
        //values to be put into database
        let usersReference = ref.child("user-favorites").child(uid!).child((item?.itemID)!)
        let values = ["sellerID": item?.seller!]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err ?? "")
                return
            }
        })
        let image = UIImage(named: "favoriteFilled")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(unfavorite))
        
        
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
        title.text = item?.title
        
        if let itemCount = item?.title?.characters.count {
            if(itemCount < 20){
                title.font = UIFont.boldSystemFont(ofSize: 24)
            } else if (itemCount >= 20 && itemCount < 26){
                title.font = UIFont.boldSystemFont(ofSize: 18)
            } else {
                title.font = UIFont.boldSystemFont(ofSize: 16)
            }
        } else {
            title.font = title.font.withSize(24)
        }
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor.darkGray
        title.backgroundColor = UIColor.white
        
        containerView.addSubview(title)
        
        title.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        title.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight + 12).isActive = true
        title.heightAnchor.constraint(equalToConstant: 34).isActive = true
        title.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -124).isActive = true
        
        
        let priceLabel = UILabel()
        let str = "$" + (item?.price!)!
        priceLabel.text = str
        
        if let priceCount = item?.price?.characters.count {
            if(priceCount < 5){
                priceLabel.font = UIFont.boldSystemFont(ofSize: 24)
            } else if (priceCount >= 5 && priceCount < 7){
                priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
            } else {
                priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
            }
        } else {
            priceLabel.font = title.font.withSize(24)
        }
        
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
        
   
        let imageLabel = UILabel()
        imageLabel.text = "Images"
        imageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.textColor = UIColor.darkGray
        imageLabel.backgroundColor = UIColor.white
        
        containerView.addSubview(imageLabel)
        
        imageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        imageLabel.topAnchor.constraint(equalTo: titleSeparator.bottomAnchor, constant: 12).isActive = true
        imageLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        imageLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        
        
        let messageSellerButton = UIButton(type: .system)
        messageSellerButton.setTitle("Message Seller", for: .normal)
        messageSellerButton.setTitleColor(UIColor.white, for: .normal)
        messageSellerButton.translatesAutoresizingMaskIntoConstraints = false
        messageSellerButton.addTarget(self, action: #selector(messageSeller), for: .touchUpInside)

        
        containerView.addSubview(messageSellerButton)
        
        messageSellerButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        messageSellerButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12).isActive = true
        messageSellerButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        messageSellerButton.widthAnchor.constraint(equalToConstant: 125).isActive = true

        
        messageSellerButton.backgroundColor = UIColor(red: 1/255, green: 112/255, blue: 111/255, alpha: 1)
        
        
        let makeOfferButton = UIButton(type: .system)
        makeOfferButton.setTitle("Make Offer", for: .normal)
        makeOfferButton.setTitleColor(UIColor.white, for: .normal)
        makeOfferButton.translatesAutoresizingMaskIntoConstraints = false
        makeOfferButton.addTarget(self, action: #selector(makeOffer), for: .touchUpInside)
        
        
        containerView.addSubview(makeOfferButton)
        
        makeOfferButton.rightAnchor.constraint(equalTo: messageSellerButton.leftAnchor, constant: -12).isActive = true
        makeOfferButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12).isActive = true

        

        makeOfferButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        makeOfferButton.widthAnchor.constraint(equalToConstant: 125).isActive = true

        
        
        makeOfferButton.backgroundColor = UIColor(red: 1/255, green: 112/255, blue: 111/255, alpha: 1)
        
        
        
        
        let zipcodeLabel = UILabel()
        zipcodeLabel.text = item?.zipcode
        zipcodeLabel.font = zipcodeLabel.font.withSize(22)
        zipcodeLabel.translatesAutoresizingMaskIntoConstraints = false
        zipcodeLabel.textColor = UIColor.darkGray
        zipcodeLabel.backgroundColor = UIColor.white
        
        containerView.addSubview(zipcodeLabel)
        
        zipcodeLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        zipcodeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12).isActive = true
        zipcodeLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        zipcodeLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        let zipcodeTitle = UILabel()
        zipcodeTitle.text = "Zipcode"
        zipcodeTitle.font = UIFont.boldSystemFont(ofSize: 20)
        zipcodeTitle.translatesAutoresizingMaskIntoConstraints = false
        zipcodeTitle.textColor = UIColor.darkGray
        
        containerView.addSubview(zipcodeTitle)
        
        zipcodeTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        zipcodeTitle.bottomAnchor.constraint(equalTo: zipcodeLabel.topAnchor, constant: -12).isActive = true
        zipcodeTitle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        zipcodeTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        
        let descSeparator = UIView()
        descSeparator.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        descSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(descSeparator)
        
        descSeparator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        descSeparator.bottomAnchor.constraint(equalTo: zipcodeTitle.topAnchor, constant: -12).isActive = true
        descSeparator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        descSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        
        
        var imageView : UIImageView
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            imageView  = UIImageView(frame:CGRect(x: 0, y: 112, width: self.view.frame.size.width, height: 150));
        } else {
            imageView  = UIImageView(frame:CGRect(x: 0, y: 112, width: self.view.frame.size.width, height: 200));
        }
        

        
        imageView.image = UIImage(named:"lixin.png")
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        
        let descTitle = UILabel()
        descTitle.text = "Description"
        descTitle.font = UIFont.boldSystemFont(ofSize: 20)
        descTitle.translatesAutoresizingMaskIntoConstraints = false
        descTitle.textColor = UIColor.darkGray
        
        containerView.addSubview(descTitle)
        
        descTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        descTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        descTitle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        descTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        
        
        let descLabel = UITextView()
        descLabel.text = item?.desc
        descLabel.font = descLabel.font?.withSize(18)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.textColor = UIColor.darkGray
        descLabel.backgroundColor = UIColor.white
        descLabel.isEditable = false
        
        containerView.addSubview(descLabel)
        
        descLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        descLabel.topAnchor.constraint(equalTo: descTitle.bottomAnchor).isActive = true
        descLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -24).isActive = true
        
        if DeviceType.IS_IPHONE_6P || DeviceType.IS_IPHONE_7P{
            descLabel.heightAnchor.constraint(equalToConstant: 190).isActive = true
        } else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_7{
            descLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
            descLabel.font = descLabel.font?.withSize(16)
        } else if DeviceType.IS_IPHONE_5 {
            
            descLabel.font = descLabel.font?.withSize(14)
            descLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
            makeOfferButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
            makeOfferButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
            makeOfferButton.titleLabel?.adjustsFontSizeToFitWidth = true
            messageSellerButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
            messageSellerButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
            messageSellerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        } else if DeviceType.IS_IPHONE_4_OR_LESS {
            descLabel.font = descLabel.font?.withSize(14)
            descLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            makeOfferButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
            makeOfferButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
            makeOfferButton.titleLabel?.adjustsFontSizeToFitWidth = true
            messageSellerButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
            messageSellerButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
            messageSellerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        
        
        
        let zipSeparator = UIView()
        zipSeparator.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        zipSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(zipSeparator)
        
        zipSeparator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        zipSeparator.topAnchor.constraint(equalTo: zipcodeLabel.bottomAnchor, constant: 12).isActive = true
        zipSeparator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        zipSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        

    }
    
    
    
    var bgImage: UIImageView?
    func messageSeller(){
        guard let chatPartnerID = item?.seller! else {
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerID)
        ref.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            let userr = user()
            userr.id = chatPartnerID
            userr.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user: userr)
        }, withCancel: nil)
    }
    
    func showChatControllerForUser(user: user){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user2 = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeOffer(){
        
    }
    
    enum UIUserInterfaceIdiom : Int
    {
        case Unspecified
        case Phone
        case Pad
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
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
