//
//  NewMessageController.swift
//  Ketch
//
//  Created by Connor Butler on 3/5/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//
//
//  This view controller is able to create a new message from the MessageController

import UIKit
import Firebase
class NewMessageController: UITableViewController {
    let cellID = "cellId"
    var users = [user]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        fetchUser()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
    }
    
    func fetchUser(){
        //get ref to database
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let userr = user()
                userr.id = snapshot.key
                userr.setValuesForKeys(dictionary)
                self.users.append(userr)
                DispatchQueue.main.async {
                    //reloads the tableView with all user's name/email *MUST call async func so the app does not crash from this thread*
                    self.tableView.reloadData()
                }
            }}, withCancel: nil)
    }
    func handleCancel(){
        //dismisses the NewMessageController to return to the MessageController
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        cell.textLabel?.text = user.name
        cell.imageView?.contentMode = .scaleAspectFill
        cell.detailTextLabel?.text = user.email
        cell.imageView?.image = UIImage(named: "person")
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessageController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true){
            let user = self.users[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            self.messagesController?.showChatControllerForUser(user: user)
        }
    }

}



