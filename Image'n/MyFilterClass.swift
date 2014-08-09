//
//  MyFilterClass.swift
//  Image'n
//
//  Created by Alex on 8/7/14.
//  Copyright (c) 2014 Alex Rice. All rights reserved.
//

import UIKit
import Photos

class MyFilterClass: NSObject {
    
    
    
    class func applyFilterToAsset(filterName: String, asset: PHAsset) {
        
        let adjustmentFormatterIndentifier = "com.alexhomework.cf"
        var myCIContext = CIContext(options: nil)
        
        var options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(data : PHAdjustmentData!) -> Bool in
            return data.formatIdentifier == adjustmentFormatterIndentifier && data.formatVersion == "1.0"
        }
    
        asset.requestContentEditingInputWithOptions(options, completionHandler: { (contentEditingInput: PHContentEditingInput!, [NSObject : AnyObject]!) -> Void in
            var url = contentEditingInput.fullSizeImageURL
            
            var imageToFilter = CIImage(contentsOfURL: url)
            var orientation = contentEditingInput.fullSizeImageOrientation
            imageToFilter = imageToFilter.imageByApplyingOrientation(orientation)
            
            var filter = CIFilter(name: filterName)
            filter.setDefaults()
            filter.setValue(imageToFilter, forKey: kCIInputImageKey)
            var filteredImage = filter.outputImage
            
            var cgimg = myCIContext.createCGImage(filteredImage, fromRect: filteredImage.extent())
            var finalImage = UIImage(CGImage: cgimg)
            var jpgData = UIImageJPEGRepresentation(finalImage, 0.5) //why did this make me get rid of the "compression quality:" label?
            
            var adjustmentData = PHAdjustmentData(formatIdentifier: adjustmentFormatterIndentifier, formatVersion: "1.0", data: nil)
            var contentEditingOutput = PHContentEditingOutput(contentEditingInput: contentEditingInput)
            jpgData.writeToURL(contentEditingOutput.renderedContentURL, atomically: true)
            contentEditingOutput.adjustmentData = adjustmentData
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                var request = PHAssetChangeRequest(forAsset: asset)
                request.contentEditingOutput = contentEditingOutput
                },
                completionHandler: { (success : Bool, error : NSError!) -> Void in
                    if !success {
                        println(error.localizedDescription)
                    }
                })
        })
    }
    
//    class func thumbnailFromAsset(asset: PHAsset, withFilter filter: String, completionHandler: (image: UIImage) -> Void) {
////        var myCIContext = CIContext(options: nil)
////        var options = PHContentEditingInputRequestOptions()
//        var url = asset.fullSizeImageURL
//        
//        var imageToFilter = CIImage(contentsOfURL: url)
//        let originalImage = CIImage(image: uiimage)
//        var filter = CIFilter(name: filter)
//        filter.setDefaults()
//        filter.setValue(originalImage, forKey: kCIInputImageKey)
//        let outputImage = filter.outputImage
//        let finalImage = UIImage(CIImage: outputImage)
//        completionHandler(image: finalImage)
//    }
    
    class func imageFromAsset(asset: PHAsset, withHeight: Int, andWidth: Int){
        
    }
}
