//
//  SellingPostTableController.swift
//  Ketch
//
//  Created by Patrick Carder on 3/28/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//
import UIKit
import Firebase

class SellingPostTableController: UITableViewController {
    
    @IBOutlet var myItems: UITableView!
    
    @IBOutlet var newItemButton: UIBarButtonItem!
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ItemCell.self, forCellReuseIdentifier: cellID)
        updateMyItems()
        
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddItem")
        self.present(controller, animated: true, completion: nil)
    }

    var items = [Items] ()
    var itemsDictionary = [String: Items]()
    func updateMyItems() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("user-item").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let itemID = snapshot.key
            let itemReference = FIRDatabase.database().reference().child("items").child(itemID)
            itemReference.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let item = Items()
                    item.setValuesForKeys(dictionary)
                    self.itemsDictionary[snapshot.key] = item
                    self.items = Array(self.itemsDictionary.values)

                    
                    
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
        return items.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let itemID = item.itemID
        let ref = FIRDatabase.database().reference().child("items").child(itemID!)
        ref.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            let itemm = Items()
            itemm.itemID = itemID
            itemm.setValuesForKeys(dictionary)
            self.showItemControllerForUser(item: itemm)
        }, withCancel: nil)
        
        
        //go to item controller
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.item = item
        return cell
    }
    
    func showItemControllerForUser(item: Items){
        let itemController = IndividualItemViewController()
        itemController.item = item
        navigationController?.pushViewController(itemController, animated: true)
    }
    
    func fetchUserAndSetupNavBarTitle(){
        
        self.navigationItem.title = "My items"
        
        
    }
    
    
    
}
