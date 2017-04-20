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


    
    @IBOutlet weak var editButton: UIImageView!
    @IBOutlet weak var checkButton: UIImageView!
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var zipLabel: UITextField!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 1/255, green: 112/255, blue: 111/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // If user is not logged in, return to LoginScreen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
            self.present(controller, animated: true, completion: nil)
        }
        else {
            self.checkButton.isHidden = true
            self.editButton.isHidden = false
            textFieldDeactive()
            self.zipLabel.keyboardType = UIKeyboardType.numberPad
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            
            view.addGestureRecognizer(tap)
            let loginButton = FBSDKLoginButton()
            //view.addSubview(loginButton)
            let yStart = view.frame.maxY - 98
            loginButton.frame = CGRect(x: 0, y: yStart, width: view.frame.width, height: 50)
            loginButton.delegate = self
            loginButton.readPermissions = ["email", "public_profile"]
            checkIfUserIsLoggedIn()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(checkTapped(gesture:)))
            // add it to the image view;
            editButton.addGestureRecognizer(tapGesture)
            // make sure imageView can be interacted with by user
            editButton.isUserInteractionEnabled = true
            
            checkButton.addGestureRecognizer(tapGesture2)
            // make sure imageView can be interacted with by user
            checkButton.isUserInteractionEnabled = true
            navigationItem.title = "My Account"
            
        }
        
    }
    
    @IBAction func goToFavorites(_ sender: UIButton) {
        let reviewController = FavoritesController()
        navigationController?.pushViewController(reviewController, animated: true)
    }
    
    @IBAction func goToReviews(_ sender: UIButton) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(uid)
        ref.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            let userr = user()
            userr.id = uid
            userr.setValuesForKeys(dictionary)
            self.goToReview(user: userr)
            
        }, withCancel: nil)
    }

    @IBAction func logout(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func goToSupport(_ sender: UIButton) {
        if let url = NSURL(string: "https://ketch-b8d8a.firebaseapp.com/support/index.html"){ UIApplication.shared.open(url as URL, options: [:], completionHandler: nil) }
    }

    func goToReview(user: user){
        let reviewController = RatingController()
        reviewController.user = user
        navigationController?.pushViewController(reviewController, animated: true)
    }
    
    func imageTapped(gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil {
            self.editButton.isHidden = true
            self.checkButton.isHidden = false
            textFieldActive()
            self.editButton.isHidden = true
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
            self.editButton.isHidden = false
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
