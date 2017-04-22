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

class NewItem: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate ,
    UIAlertViewDelegate {
    
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet var itemTitle: UITextField!
    @IBOutlet var itemDesc: UITextField!
    @IBOutlet var itemPrice: UITextField!
    @IBOutlet var itemZip: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    
    let uuid = UUID().uuidString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.itemPrice.keyboardType = UIKeyboardType.numberPad
        self.itemZip.keyboardType = UIKeyboardType.numberPad
    }
    
    
    
    let step: Float = 1
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        if roundedValue == 0 {
            conditionLabel.text = "Other"
        } else if roundedValue == 1 {
            conditionLabel.text = "For Parts"
        } else if roundedValue == 2 {
            conditionLabel.text = "Heavy Use"
        } else if roundedValue == 3 {
            conditionLabel.text = "Normal Wear"
        } else if roundedValue == 4 {
            conditionLabel.text = "Open Box"
        } else if roundedValue == 5{
            conditionLabel.text = "New"
        }
        
    }
    
    @IBAction func postAndReturn(_ sender: Any) {
        let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
        let itemReference = ref.child("items").child(uuid)
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let userItemReference = ref.child("user-item").child(uid!)
        
        let iName = itemTitle.text!
        let iDesc = itemDesc.text!
        let iPrice = itemPrice.text!
        let iZip = itemZip.text!
        let imageURL = uuid + ".jpg"
        let iCondition = conditionLabel.text!
        
        let storageRef = FIRStorage.storage().reference(forURL: "gs://ketch-b8d8a.appspot.com/").child(imageURL)

        if let uploadData = UIImageJPEGRepresentation(self.myImageView.image!, 0.1){
            storageRef.put(uploadData, metadata: nil, completion:
                { (metadata, error) in
                    if error != nil {
                        return
                    }
                    
                    if let itemImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["price": iPrice, "seller": uid, "title": iName, "zipcode": iZip, "desc": iDesc, "itemID": self.uuid, "itemImage": itemImageUrl, "condition": iCondition] as [String : Any]
                        
                        
                        if (iName == "") {
                            let alert = UIAlertController(title: "No Title Given",
                                                          message: "Please enter a valid title for the item.",
                                                          preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        
                        if (iZip.characters.count != 5) {
                            let alert = UIAlertController(title: "Not a Valid Zipcode",
                                                          message: "Please enter a valid 5 number zipcode.",
                                                          preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        userItemReference.updateChildValues([self.uuid:1])
                        
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
            })
        }
        
        
        
        
        
        
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func uploadImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true){
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImageView.image = image        }
        else {
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        itemZip.resignFirstResponder()
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let controller = storyboard.instantiateViewController(withIdentifier: "Dashboard")
        //self.present(controller, animated: true, completion: nil)
    }
}
