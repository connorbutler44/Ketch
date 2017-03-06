//
//  MessageController.swift
//  Ketch
//
//  Created by Connor Butler on 3/5/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        let image = UIImage(named: "editIcon1")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
    }
    func handleNewMessage(){
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay:0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dictionary["name"] as? String
                    
                }
            }, withCancel: nil)
        }
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
