//
//  PopupViewController.swift
//  Ketch
//
//  Created by Connor Butler on 4/6/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase

class PopupViewController: UIViewController {

    @IBOutlet weak var zipcodeID: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitZipcode(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference(fromURL: "https://ketch-b8d8a.firebaseio.com/")
        //values to be put into database
        let usersReference = ref.child("users").child(uid!)
        let values = ["zipcode": zipcodeID.text]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err ?? "")
                return
            }
        })
        
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }


}
