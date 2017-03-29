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
import FirebaseStorage

class NewItem: UIViewController {
    
    @IBOutlet var postButton: UIButton!
    @IBOutlet var itemTitle: UITextField!
    @IBOutlet var itemDesc: UITextField!
    @IBOutlet var itemPrice: UITextField!
    @IBOutlet var itemZip: UITextField!
    
    @IBOutlet var uploadImage: UIButton!
    
    @IBOutlet var cancelButton: UIButton!
    
    let uuid = UUID().uuidString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func postAndReturn(_ sender: UIButton) {
        let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
        

        let iName = itemTitle.text!
        let iDesc = itemDesc.text!
        let iPrice = itemPrice.text!
        let iZip = itemZip.text!
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let itemReference = ref.child("items").child(uuid)
        let userItemReference = ref.child("user-item").child(uid!)
        
        let values = ["price": iPrice, "seller": uid, "sold": false, "title": iName, "zCode": iZip, "zDesc": iDesc] as [String : Any]

        userItemReference.updateChildValues([uuid:1])
        
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        let localFile = URL(string: "path/to/image")!
        let storageRef = FIRStorage.storage().reference(forURL: "gs://ketch-b8d8a.appspot.com/")
        let pictureRef = storageRef.child(uuid)
        
        let uploadTask = pictureRef.putFile(localFile, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL()
            }
        }
        
        
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        itemZip.resignFirstResponder()
    }
    
    @IBAction func cancelPost(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Dashboard")
        self.present(controller, animated: true, completion: nil)
    }
}
