//
//  ItemListController.swift
//  Ketch
//
//  Created by Connor Butler on 2/17/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//  
//
//  This is view controller shows all items listed in the database

import UIKit

class ItemListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let products = ["img1", "img2", "img3", "img4", "img5", "img6", "img7", "img8"]
    let imageArray = [UIImage(named:"img1"), UIImage(named:"img2"), UIImage(named:"img3"), UIImage(named:"img4"),UIImage(named:"img5"), UIImage(named:"img6"), UIImage(named:"img7"), UIImage(named:"img8")]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let image = UIImage(named: "editIcon1")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView?.image = self.imageArray[indexPath.row]
        cell.titleLabel?.text = self.products[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage"
        {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as IndexPath
            
            let vc = segue.destination as! IndividualItemViewController
            
            vc.image = self.imageArray[indexPath.row]!
            vc.title = self.products[indexPath.row]
            
        }
    }

}
