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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMyItems()
        
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddItem")
        self.present(controller, animated: true, completion: nil)
    }

    
    func updateMyItems() {
        let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        let itemRef = ref.child("user-item").child(uid!)
              
    }
    
}
