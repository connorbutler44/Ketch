//
//  SellingPost.swift
//  Ketch
//
//  Created by Patrick Carder on 3/11/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase

class SellingPost: UIViewController {
    
    @IBOutlet var newItemButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddItem")
        self.present(controller, animated: true, completion: nil)
        
    }
    
}
