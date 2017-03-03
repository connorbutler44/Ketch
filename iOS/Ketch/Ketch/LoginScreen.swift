//
//  LoginScreen.swift
//  Ketch
//
//  Created by Connor Butler on 2/27/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginScreen: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            /*
            Regular FB login button
             
            let loginButton = FBSDKLoginButton()
            view.addSubview(loginButton)
            loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
            loginButton.delegate = self
            loginButton.readPermissions = ["email", "public_profile"]
            */
            
            //custom login button
            print("user is currently logged out")
             let customFBButton = UIButton()
            customFBButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
            customFBButton.setTitleColor(.white, for: .normal)
             customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
            customFBButton.center = self.view.center
             customFBButton.setTitle("Log in with Facebook", for: .normal)
             customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
             customFBButton.setTitleColor(.white, for: .normal)
             view.addSubview(customFBButton)
             customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
            
        }
        else
        {
            print("User is currently logged in - go to dashboard")
            perform(#selector(userLoggedIn), with: nil, afterDelay: 0)
        }
    }
    
    func userLoggedIn(){
        //when user is logged it it goes to the dashboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Dashboard")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func handleCustomFBLogin(){
        //custom Facebook login function to grab user and add them to firebase
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self)
        {
            (result, err) in
            if err != nil {
                print("FB Login failed:")
                return
            }
            self.showEmailAddress()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Dashboard")
            self.present(controller, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Successfully logged out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        self.showEmailAddress()
        
    }
    
    func showEmailAddress(){
        let accessToken = FBSDKAccessToken.current()
        guard (accessToken?.tokenString) != nil else { return }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
            self.userLoggedIn()
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start{(
            connection, result, err) in
            if err != nil{
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
