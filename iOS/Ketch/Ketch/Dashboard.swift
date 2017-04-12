//
//  Dashboard.swift
//  Ketch
//
//  Created by Connor Butler on 3/3/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//
//
//  This Dashboard consists of ItemListController, MyAccount and MessageMessageController

import UIKit
import Firebase

class Dashboard: UITabBarController, UIPopoverPresentationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserHasZipcode()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfUserHasZipcode(){
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let zipcode = dictionary["zipcode"] as? String
                print(dictionary["zipcode"])
                if(zipcode == ""){
                    self.setUserZipcode()
                }
            }
        }, withCancel: nil)
        
        
        
    }
    
    
    
    func setUserZipcode(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopupID") as! PopupViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
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
