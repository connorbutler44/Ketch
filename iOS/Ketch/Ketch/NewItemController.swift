//
//  NewItem.swift
//  Ketch
//
//  Created by Patrick Carder on 3/21/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewItem: UIViewController {
    
    @IBOutlet var postButton: UIButton!
    @IBOutlet var itemTitle: UITextField!
    @IBOutlet var itemDesc: UITextField!
    @IBOutlet var itemPrice: UITextField!
    @IBOutlet var itemZip: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func postAndReturn(_ sender: UIButton) {
        let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
        
        let uuid = UUID().uuidString
        let iName = itemTitle.text!
        let iDesc = itemDesc.text!
        let iPrice = itemPrice.text!
        let iZip = itemZip.text!
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let itemReference = ref.child("items").child(uuid)
        
        let values = ["price": iPrice, "seller": uid, "sold": false, "title": iName, "zCode": iZip, "zDesc": iDesc] as [String : Any]
        
        itemReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err ?? "")
                return
            }
            print("Item saved successfully into Firebase")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Dashboard")
        self.present(controller, animated: true, completion: nil)
    })
    
    
}
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        itemZip.resignFirstResponder()
    }
}
