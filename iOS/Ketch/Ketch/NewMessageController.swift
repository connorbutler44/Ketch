//
//  NewMessageController.swift
//  Ketch
//
//  Created by Connor Butler on 3/5/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

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
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let userr = user()
                userr.setValuesForKeys(dictionary)
                self.users.append(userr)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }}, withCancel: nil)
    }
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
    

}

class UserCell: UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
