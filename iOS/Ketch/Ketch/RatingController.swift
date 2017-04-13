//
//  RatingController.swift
//  Ketch
//
//  Created by Connor Butler on 4/12/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

//
//  MessageController.swift
//  Ketch
//
//  Created by Connor Butler on 3/5/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//
//
//
//  This view controller shows all of a users current messages

import UIKit
import Firebase

class RatingController: UITableViewController {
    let cellID = "cellID"
    
    var user: user? {
        didSet{
            if FIRAuth.auth()?.currentUser?.uid == user?.id{
                var str = "My reviews"
                navigationItem.title = str
                print("user reference set")
            } else {
                var str = "Reviews for " + (user?.name)!
                navigationItem.title = str
                print("user reference set")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReviewCell.self, forCellReuseIdentifier: cellID)
        //Makes sure the user is logged in, if not return to the LoginScreen
        checkIfUserIsLoggedIn()
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        let image = UIImage(named: "back")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleBack))
        observeUserReviews()
        
    }
    var reviews = [review] ()
    var ratingsDictionary = [String: review]()
    func observeUserReviews(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("user-rating").child((user?.id)!)
        ref.observe(.childAdded, with: { (snapshot) in
            let itemID = snapshot.key
            let itemReference = FIRDatabase.database().reference().child("ratings").child(itemID)
            itemReference.observe(.value, with: { (snapshot) in
                 if let dictionary = snapshot.value as? [String: AnyObject]{
                    let rating = review()
                    rating.setValuesForKeys(dictionary)
                    self.ratingsDictionary[snapshot.key] = rating
                    self.reviews = Array(self.ratingsDictionary.values)

                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                    
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var timer: Timer?
    
    func handleReloadTable(){
        DispatchQueue.main.async {
            //reloads the tableView with all user's name/email *MUST call async func so the app does not crash from this thread*
            self.tableView.reloadData()
        }
    }
    
    func handleBack(){
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.title = FIRAuth.auth()?.currentUser?.uid
        //navigationController?.popViewController(messageController, animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let review2 = reviews[indexPath.row]
        guard let reviewID = review2.ratingID else {
            return
        }
        let ref = FIRDatabase.database().reference().child("ratings").child(reviewID)
        
        ref.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject?] else {
                return
            }
            let revieww = review()
            revieww.ratingID = reviewID
            revieww.setValuesForKeys(dictionary)
            tableView.deselectRow(at: indexPath, animated: true)
            self.showReviewController(review: revieww)
        }, withCancel: nil)
        
        
        
        
        
        
    }
    
    func showReviewController(review: review){
        let reviewController = IndividualReviewController()
        reviewController.review = review
        navigationController?.pushViewController(reviewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ReviewCell
        let revieww = reviews[indexPath.row]
        cell.review = revieww
        return cell
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay:0)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    func showChatControllerForUser(user: user){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user2 = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleLogout(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginScreen()
        present(loginController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    
}

