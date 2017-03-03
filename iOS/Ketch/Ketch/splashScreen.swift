//
//  splashScreen.swift
//  Ketch
//
//  Created by Connor Butler on 3/3/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit

class splashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.uid != nil {
            print("logged in")
            loggedIn()
            
        } else {
            print("logged out")
            loggedOut()
        }
        
        // Do any additional setup after loading the view.
    }
    func loggedIn(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Dashboard")
        self.present(controller, animated: true, completion: nil)
    }
    
    func loggedOut(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Login")
        self.present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
