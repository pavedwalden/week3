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
    
    
    
    var filterBundles : [FilterBundle] = []
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
        
        filterBundles.append(FilterBundle(filterName: "CISepiaTone"))
        filterBundles.append(FilterBundle(filterName: "CISepiaTone"))
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
        var filterBundle = filterBundles[indexPath.item]
        if cell.imageView != nil {
        cell.imageView.image = filterBundle.getThumbnail()
        }
        
        return cell     }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return filterBundles.count
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        println("selected item at \(indexPath)")
        applyFilterFunc("CISepiaTone", originalAsset: passedAsset!)
    }
    
    
    // MARK: Filtering
    func applyFilterFunc(filterName: String, originalAsset: PHAsset) {
        //can I build 'recepies' by passing an array fo filter names?
        
        var options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(data : PHAdjustmentData!) -> Bool in
            return data.formatIdentifier == self.adjustmentFormatterIndentifier && data.formatVersion == "1.0"
        }
        
        var asset = originalAsset //artafact from earlier debugging that I'm keeping around because i may repeat the process

        asset.requestContentEditingInputWithOptions(options, completionHandler: { (contentEditingInput: PHContentEditingInput!, [NSObject : AnyObject]!) -> Void in
            var url = contentEditingInput.fullSizeImageURL
            
            var imageToFilter = CIImage(contentsOfURL: url)
            var orientation = contentEditingInput.fullSizeImageOrientation
            imageToFilter = imageToFilter.imageByApplyingOrientation(orientation)
            
            var filter = CIFilter(name: filterName)
            filter.setDefaults()
            filter.setValue(imageToFilter, forKey: kCIInputImageKey)
            var filteredImage = filter.outputImage
            
            if filter == nil {
                println("You probably passed an invalid filter name")
            }
            
            var cgimg = self.myCIContext.createCGImage(filteredImage, fromRect: filteredImage.extent())
            var finalImage = UIImage(CGImage: cgimg)
            var jpgData = UIImageJPEGRepresentation(finalImage, 0.5) //why did this make me get rid of the "compression quality:" label?
            
            var adjustmentData = PHAdjustmentData(formatIdentifier: self.adjustmentFormatterIndentifier, formatVersion: "1.0", data: jpgData)
            var contentEditingOutput = PHContentEditingOutput(contentEditingInput: contentEditingInput)
            jpgData.writeToURL(contentEditingOutput.renderedContentURL, atomically: true)
            contentEditingOutput.adjustmentData = adjustmentData
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                var request = PHAssetChangeRequest(forAsset: asset)
                request.contentEditingOutput = contentEditingOutput
                
                }, completionHandler: { (success : Bool, error : NSError!) -> Void in
                    if !success {
                        println(error.localizedDescription)
                    }
            })
            var mainVC = self.navigationController.viewControllers[0] as FirstViewController
            mainVC.displayedAsset = self.passedAsset!
            //mainVC.loadAssetIntoImageView(self.passedAsset!)
            self.navigationController.popToViewController(mainVC, animated: true)
        })
        
    }

}
