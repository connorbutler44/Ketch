//
//  itemZoomController.swift
//  Ketch
//
//  Created by Connor Butler on 4/16/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase

class ItemZoomController: UIViewController {
    
    var item: Items? {
        didSet{
            print("item reference set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        self.setupInputComponents()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 350, height: 350))
        containerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let itemImageURL = item?.itemImage {
            imageView.loadImageUsingCacheWithURLString(urlString: itemImageURL)
        }
        var exit = UIImageView()
        exit = UIImageView(frame:CGRect(x: 0, y: 0, width: 25, height: 25))
        containerView.addSubview(exit)
        exit.translatesAutoresizingMaskIntoConstraints = false
        exit.image = UIImage(named: "minimize")
        containerView.updateConstraints()
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
