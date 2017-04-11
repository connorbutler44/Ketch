//
//  NewViewController.swift
//  Ketch
//
//  Created by Connor Butler on 2/17/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//
//
//  This view controller shows an individual item from the ItemListController with it's corresponding data from Firebase

import UIKit
import Firebase

class IndividualItemViewController: UIViewController{

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemDesc: UITextView!
    
    var item: Items? {
        didSet{
            itemTitle.text = item?.title
        }
    }
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
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
