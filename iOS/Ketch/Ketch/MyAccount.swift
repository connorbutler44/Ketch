//
//  MyAccount.swift
//  Ketch
//
//  Created by Connor Butler on 3/3/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//
//
//
//  This view controller displays data pertinent to the individual user

import UIKit
import Firebase
import FBSDKLoginKit

class MyAccount: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var checkButton: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var zipLabel: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // If user is not logged in, return to LoginScreen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
            self.present(controller, animated: true, completion: nil)
        }
        else {
            self.checkButton.isHidden = true
            self.editImage.isHidden = false
            textFieldDeactive()
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            
            view.addGestureRecognizer(tap)
            let loginButton = FBSDKLoginButton()
            view.addSubview(loginButton)
            let yStart = view.frame.maxY - 98
            loginButton.frame = CGRect(x: 0, y: yStart, width: view.frame.width, height: 50)
            loginButton.delegate = self
            loginButton.readPermissions = ["email", "public_profile"]
            checkIfUserIsLoggedIn()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(checkTapped(gesture:)))
            // add it to the image view;
            editImage.addGestureRecognizer(tapGesture)
            // make sure imageView can be interacted with by user
            editImage.isUserInteractionEnabled = true
            
            checkButton.addGestureRecognizer(tapGesture2)
            // make sure imageView can be interacted with by user
            checkButton.isUserInteractionEnabled = true
        }
        
    }
    
    func imageTapped(gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil {
            self.editImage.isHidden = true
            self.checkButton.isHidden = false
            textFieldActive()
            self.editImage.isHidden = true
        }
    }
    
    func checkTapped(gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil {
            let uid = FIRAuth.auth()?.currentUser?.uid
            let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
            //values to be put into database
            let usersReference = ref.child("users").child(uid!)
            let values = ["zipcode": self.zipLabel.text]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err ?? "")
                    return
                }
            })
            textFieldDeactive()
            self.editImage.isHidden = false
            self.checkButton.isHidden = true
        }
    }
    
    
    func textFieldActive(){
        zipLabel.isEnabled = true
    }
    
    func textFieldDeactive(){
        zipLabel.isEnabled = false
    }
    
    func checkIfUserIsLoggedIn(){
        // Checks if logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(loginButtonDidLogOut), with: nil, afterDelay:0)
        } else {
            // Get reference to database and pulls the user's name and email
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.nameLabel.text = dictionary["name"] as? String
                    self.emailLabel.text = dictionary["email"] as? String
                    self.zipLabel.text = dictionary["zipcode"] as? String

                }
            }, withCancel: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
        self.present(controller, animated: true, completion: nil)
        print("Successfully logged out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    


}
