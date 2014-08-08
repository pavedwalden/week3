//
//  FilterViewController.swift
//  Image'n
//
//  Created by Alex on 8/6/14.
//  Copyright (c) 2014 Alex Rice. All rights reserved.
//

import UIKit



class FilterViewController: UICollectionViewController {

    let filterReuseIdentifier = "filterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(filterReuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        return cell
    }

}
