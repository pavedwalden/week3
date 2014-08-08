//
//  MyCollectionViewController.swift
//  Image'n
//
//  Created by Alex on 8/5/14.
//  Copyright (c) 2014 Alex Rice. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "Cell"

class MyCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    
    var fetchedAssets : PHFetchResult?
    var imageManager : PHCachingImageManager?
    var thumbnailSize : CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()
        // The example code does the following things in "View Will Appear". I'm trying them
        // out here and I'll probably learn the hard way why they belong in the other place.
        var scale = UIScreen.mainScreen().scale
        var layout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        var cellSize = layout.itemSize

        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.dataSource = self
        fetchedAssets = PHAsset.fetchAssetsWithOptions(nil)
        self.imageManager = PHCachingImageManager()
        
        self.thumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedAssets!.count
    }

    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gridCell", forIndexPath: indexPath) as GridCell
    
        var asset = self.fetchedAssets![indexPath.item] as PHAsset
        self.imageManager?.requestImageForAsset(asset, targetSize: self.thumbnailSize!, contentMode: PHImageContentMode.AspectFill, options: nil) { (result : UIImage!, [NSObject : AnyObject]!) -> Void
            in

                cell.imageView.image = result

        }
        
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let photoViewController = segue.destinationViewController as PhotoViewController
        let path = self.collectionViewOutlet.indexPathForCell(sender as GridCell)
        if let indexPath = self.collectionView.indexPathForCell(sender as GridCell){
            photoViewController.passedAsset = self.fetchedAssets![path.item] as? PHAsset
        }
    }


}
