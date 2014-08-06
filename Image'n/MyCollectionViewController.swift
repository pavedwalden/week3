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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.fetchedAssets!.count
    }

    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as pictureThumbnailViewCell
    
        var asset = self.fetchedAssets![indexPath.item] as PHAsset
        self.imageManager?.requestImageForAsset(asset, targetSize: self.thumbnailSize!, contentMode: PHImageContentMode.AspectFill, options: nil) { (result : UIImage!, [NSObject : AnyObject]!) -> Void
            in

                cell.image.image = result

        }
        
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let photoViewController = segue.destinationViewController as PhotoViewController
        let path = self.collectionViewOutlet.indexPathForCell(sender as pictureThumbnailViewCell)
        if let indexPath = self.collectionView.indexPathForCell(sender as pictureThumbnailViewCell){
            photoViewController.passedAsset = self.fetchedAssets![path.item] as? PHAsset
        }
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView!, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, canPerformAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, performAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) {
    
    }
    */

}
