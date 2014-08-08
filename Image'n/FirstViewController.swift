//
//  ViewController.swift
//  Image'n
//
//  Created by Alex on 8/4/14.
//  Copyright (c) 2014 Alex Rice. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPhotoLibraryChangeObserver {
    
    @IBAction func testButton(sender: AnyObject) {
        println("test button")
        
        var width = CGRectGetWidth(self.myImageView.frame)
        var height = CGRectGetHeight(self.myImageView.frame)
        var scale = UIScreen.mainScreen().scale
        
        println("Height: \(height), Width:\(width), Scale:\(scale)")
        
        imageManager.requestImageForAsset(displayedAsset!,
            targetSize: CGSize(width: width * scale,
                height: height * scale),
            contentMode: PHImageContentMode.AspectFill, options: nil)
            { (result : UIImage!, [NSObject : AnyObject]!) -> Void
                in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.myImageView.image = result
                })
        }

//        loadAssetIntoImageView(displayedAsset!)
//        println(displayedAsset?.description)
//        self.myImageView.backgroundColor = UIColor.blackColor()
    }
    
    
    @IBOutlet weak var myImageView: UIImageView!
    
    let imageManager = PHCachingImageManager()
    var displayedAsset : PHAsset?
    let libraryPicker = UIImagePickerController()
    let cameraPicker = UIImagePickerController()
    var image : UIImage?
    
    var sheetController = UIAlertController(title: "Choose A Photo", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
    var alertController = UIAlertController(title: "Hey", message: "we need permission to open your photos", preferredStyle: UIAlertControllerStyle.Alert)
    
    
    let adjustmentFormatterIndentifier = "com.alexhomework.cf"
    var myCIContext = CIContext(options: nil)
    
    
    @IBAction func getPhotoButtonPressed(sender: AnyObject) {
//        let authStatus = ALAssetsLibrary.authorizationStatus()
//        let needsPermission = !(authStatus == ALAuthorizationStatus.Authorized)
//        if (needsPermission) {
//            self.presentViewController(alertController, animated: true, completion: nil)
//        } else {
//            self.presentViewController(self.sheetController, animated: true, completion: nil)
//        }
        self.performSegueWithIdentifier("toCollectionVC", sender: self)
    }
    

    @IBAction func applyFilter(sender: AnyObject) {
    }
    
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertController.addAction(UIAlertAction(title: "Screw that!", style: UIAlertActionStyle.Cancel, handler: {(action: UIAlertAction!) -> Void
            in
            self.dismissViewControllerAnimated(true, completion: nil)
            }))
        alertController.addAction(UIAlertAction(title: "Oh, ok.", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void
            in
            println("1st Completion")
            self.dismissViewControllerAnimated(true, completion: {() -> Void
                in
                println("2nd completion") //For some reason, this is not getting executed
                self.presentViewController(self.sheetController, animated: true, completion: nil)
                })
            self.presentViewController(self.sheetController, animated: true, completion: nil)
            //^^ should be redundant, but this is a tempoary hack until I figure out why
            //  the 2nd completion isn't firing
            }))
        
        libraryPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        libraryPicker.delegate = self
        
        sheetController.addAction(UIAlertAction(title: "Existing Photo", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!)-> Void
            in
            self.presentViewController(self.libraryPicker, animated: true, completion: nil)
            }))
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            cameraPicker.sourceType = UIImagePickerControllerSourceType.Camera
            cameraPicker.delegate = self
            sheetController.addAction(UIAlertAction(title: "New Photo", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!)-> Void
                in
                self.presentViewController(self.cameraPicker, animated: true, completion: nil)
                }))
        }
        
        sheetController.addAction(UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.Cancel, handler: nil))
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        myImageView.image = info[UIImagePickerControllerOriginalImage] as UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("will appear")
        self.myImageView.image = self.image
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.myImageView.image = self.image
    }
    
    func loadImageForAsset(asset: PHAsset, completionHandler: (Void) -> Void ){
        var width = CGRectGetWidth(self.myImageView.frame)
        var height = CGRectGetHeight(self.myImageView.frame)
        var scale = UIScreen.mainScreen().scale
        
        println("Height: \(height), Width:\(width), Scale:\(scale)")
        
        self.displayedAsset = asset
        if displayedAsset != nil {
            
            imageManager.requestImageForAsset(self.displayedAsset!,
                targetSize: CGSize(width: width * scale,
                    height: height * scale),
                contentMode: PHImageContentMode.AspectFill, options: nil)
                { (result : UIImage!, [NSObject : AnyObject]!) -> Void
                    in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.image = result
                        self.navigationController.popToViewController(self, animated: true)
                        println("Popping to root VC")
                    })
            }
        } else {
            println("no asset to load")
        }
        
    }
    
    func loadAssetIntoImageView(asset: PHAsset) {
        self.displayedAsset = asset
        var width = CGRectGetWidth(self.myImageView.frame)
        var height = CGRectGetHeight(self.myImageView.frame)
        var scale = UIScreen.mainScreen().scale

        println("Height: \(height), Width:\(width), Scale:\(scale)")

        imageManager.requestImageForAsset(asset,
            targetSize: CGSize(width: width * scale,
                height: height * scale),
            contentMode: PHImageContentMode.AspectFill, options: nil)
            { (result : UIImage!, [NSObject : AnyObject]!) -> Void
                in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.image = result
                    self.navigationController.popToViewController(self, animated: true)
                    println("Popping to root VC")
                })
        }
    }

    
    func applyFilterFunc(sender: AnyObject, filterName: String) {
        //can I build 'recepies' by passing an array fo filter names?
        
        var options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(data : PHAdjustmentData!) -> Bool in
            return data.formatIdentifier == self.adjustmentFormatterIndentifier && data.formatVersion == "1.0"
        }
        
        if let asset = displayedAsset {
            asset.requestContentEditingInputWithOptions(options, completionHandler: { (contentEditingInput: PHContentEditingInput!, [NSObject : AnyObject]!) -> Void in
                var url = contentEditingInput.fullSizeImageURL
                
                var imageToFilter = CIImage(contentsOfURL: url)
                var orientation = contentEditingInput.fullSizeImageOrientation
                imageToFilter = imageToFilter.imageByApplyingOrientation(orientation)
                
                var filter = CIFilter(name: filterName)
                filter.setDefaults()
                filter.setValue(imageToFilter, forKey: kCIInputImageKey)
                var filteredImage = filter.outputImage
                
                var cgimg = self.myCIContext.createCGImage(filteredImage, fromRect: filteredImage.extent())
                var finalImage = UIImage(CGImage: cgimg)
                var jpgData = UIImageJPEGRepresentation(finalImage, 0.5) //why did this make me get rid of the "compression quality:" label?
                
                var adjustmentData = PHAdjustmentData(formatIdentifier: self.adjustmentFormatterIndentifier, formatVersion: "1.0", data: jpgData)
                var contentEditingOutput = PHContentEditingOutput(contentEditingInput: contentEditingInput)
                jpgData.writeToURL(contentEditingOutput.renderedContentURL, atomically: true)
                contentEditingOutput.adjustmentData = adjustmentData
                
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                    var request = PHAssetChangeRequest(forAsset: self.displayedAsset)
                    request.contentEditingOutput = contentEditingOutput
                    
                    }, completionHandler: { (success : Bool, error : NSError!) -> Void in
                        if !success {
                            println(error.localizedDescription)
                        }
                })
            
            self.navigationController.popToViewController(self, animated: true)
            })
        }
    }
    

    func photoLibraryDidChange(changeInstance: PHChange!) {
        println("changes detected")
        self.myImageView.image = self.image
        if let asset = displayedAsset {
            println("displayed asset was not nil")
            var width = CGRectGetWidth(self.myImageView.frame)
            var height = CGRectGetHeight(self.myImageView.frame)
            var scale = UIScreen.mainScreen().scale
            
            println("Height: \(height), Width:\(width), Scale:\(scale)")
            
            imageManager.requestImageForAsset(asset,
                targetSize: CGSize(width: width * scale,
                    height: height * scale),
                contentMode: PHImageContentMode.AspectFill, options: nil)
                { (result : UIImage!, [NSObject : AnyObject]!) -> Void
                    in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.myImageView.image = result
                    })
                }
        } else {
            println("displayed asset was nil")
        }

    }
    
}

//switch PHPhotoLibrary.authorizationStatus() {
//case.NotDetermined:
//    println("Not determined")
//        PHPhotoLibrary.requestAuthorization { (PHAuthorizationStatus) -> Void in
//            code
//        }
//case .Restricted:
//case .Denied:
//case .Authorized:
//}
