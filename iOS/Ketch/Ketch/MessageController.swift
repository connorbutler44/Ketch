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

class MessageController: UITableViewController {
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes sure the user is logged in, if not return to the LoginScreen
        checkIfUserIsLoggedIn()
        let image = UIImage(named: "editIcon1")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        //observeMessages()
        observeUserMessages()
    }
    var messages = [Message] ()
    var messagesDictionary = [String: Message]()
    func observeUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messagesReference = FIRDatabase.database().reference().child("messages").child(messageID)
            messagesReference.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    if let chatPartnerID = message.chatPartnerID(){
                        self.messagesDictionary[chatPartnerID] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) ->
                            Bool in
                            
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerID = message.chatPartnerID() else {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    func handleNewMessage(){
        // Presents the NewMessageController
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay:0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle(){
        
        // Sets the name of the title as the users name
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.navigationItem.title = dictionary["name"] as? String
                
            }
        }, withCancel: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    func showChatControllerForUser(user: user){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
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
