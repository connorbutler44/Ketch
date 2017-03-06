//
//  MyAccount.swift
//  Ketch
//
//  Created by Connor Butler on 3/3/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class MyAccount: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var UIDLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        let yStart = view.frame.maxY - 110
        loginButton.frame = CGRect(x: 16, y: yStart, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        checkIfUserIsLoggedIn()
        // Do any additional setup after loading the view.
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(loginButtonDidLogOut), with: nil, afterDelay:0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.nameLabel.text = dictionary["name"] as? String

                }
            }, withCancel: nil)
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.emailLabel.text = dictionary["email"] as? String
                    
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


}
