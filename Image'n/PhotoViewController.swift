//
//  PhotoViewController.swift
//  Image'n
//
//  Created by Alex on 8/5/14.
//  Copyright (c) 2014 Alex Rice. All rights reserved.
//

import UIKit
import Photos

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var candidateImage: UIImageView!
    var passedAsset : PHAsset?
    let imageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageManager.requestImageForAsset(passedAsset!,
                                        targetSize: CGSize(width: CGRectGetWidth(self.candidateImage.frame),
                                                           height: CGRectGetHeight(self.candidateImage.frame)),
                                        contentMode: PHImageContentMode.AspectFill, options: nil)
            { (result : UIImage!, [NSObject : AnyObject]!) -> Void
            in
            self.candidateImage.image = result
        }
    }

    
    @IBAction func userSelectedPhoto(sender: UIButton) {
        var mainVC = self.navigationController.viewControllers[0] as FirstViewController
        mainVC.displayedAsset = passedAsset
        self.navigationController.popToRootViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
