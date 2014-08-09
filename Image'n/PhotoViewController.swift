//
//  PhotoViewController.swift
//  Image'n
//
//  Created by Alex on 8/5/14.
//  Copyright (c) 2014 Alex Rice. All rights reserved.
//

import UIKit
import Photos

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // for filtering
    let adjustmentFormatterIndentifier = "com.alexhomework.cf"
    var myCIContext = CIContext(options: nil)
    // end filtering vars
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var candidateImage: UIImageView!
    
    
    
    var filters : [String] = []
    let imageManager = PHCachingImageManager()
    var passedAsset : PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        
        var height = CGRectGetHeight(self.candidateImage.frame)
        var width = CGRectGetWidth(self.candidateImage.frame)
        imageManager.requestImageForAsset(passedAsset!,
                                        targetSize: CGSize(width: width, height: height),
                                        contentMode: PHImageContentMode.AspectFill, options: nil)
            { (result : UIImage!, [NSObject : AnyObject]!) -> Void
            in
            self.candidateImage.image = result
            }
        filters.append("CIMaximumComponent")
        filters.append("CISepiaTone")
        filters.append("CIColorInvert")
        filters.append("CIMinimumComponent")
    }

    
    @IBAction func userSelectedPhoto(sender: UIButton) {
        var mainVC = self.navigationController.viewControllers[0] as FirstViewController
//        mainVC.loadImageForAsset(passedAsset!) {
//                self.navigationController.popToRootViewControllerAnimated(true)
//        }
    }

    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier( "filterCell", forIndexPath: indexPath) as pictureThumbnailViewCell
        var filterName = filters[indexPath.item]
        
        var width = CGRectGetWidth(cell.imageView.frame)
        var height = CGRectGetHeight(cell.imageView.frame)
        var scale = UIScreen.mainScreen().scale
        
        println("Height: \(height), Width:\(width), Scale:\(scale)")
        
//        imageManager.requestImageForAsset(passedAsset!,
//            targetSize: CGSize(width: width * scale,
//                height: height * scale),
//            contentMode: PHImageContentMode.AspectFill, options: nil)
//            { (result : UIImage!, [NSObject : AnyObject]!) -> Void
//                in
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    cell.imageView.image = result
//                })
//        }

        imageManager.requestImageForAsset(passedAsset!,
            targetSize: CGSize(width: width * scale,
                height: height * scale),
            contentMode: PHImageContentMode.AspectFill, options: nil)
            { (result : UIImage!, [NSObject : AnyObject]!) -> Void
                in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    var thumbnail = CIImage(image: result)
                    var filter = CIFilter(name:filterName)
                    filter.setDefaults()
                    filter.setValue(thumbnail, forKey: kCIInputImageKey)
                    var filteredImage = filter.outputImage
                    var filteredThumbnail = UIImage(CIImage: filteredImage)
                    cell.imageView.image = filteredThumbnail
                })
        }
        
        return cell     }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        println("selected item at \(indexPath)")
        var filterName = filters[indexPath.item]
        MyFilterClass.applyFilterToAsset(filterName, asset: passedAsset!)
        var mainVC = self.navigationController.viewControllers[0] as FirstViewController
        mainVC.displayedAsset = self.passedAsset!
        self.navigationController.popToViewController(mainVC, animated: true)
    }
}
