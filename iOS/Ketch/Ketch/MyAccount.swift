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

class MyAccount: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        // Do any additional setup after loading the view.
    }
    
    func handleLogout(){
        if FIRAuth.auth()?.currentUser?.uid != nil {
            do {
                try FIRAuth.auth()?.signOut()
            } catch let logoutError {
                print(logoutError)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
            self.present(controller, animated: true, completion: nil)
        }
    }
    @IBAction func logoutButton(_ sender: Any) {
        handleLogout()
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
