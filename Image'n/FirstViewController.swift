//
//  ViewController.swift
//  Image'n
//
//  Created by Alex on 8/4/14.
//  Copyright (c) 2014 Alex Rice. All rights reserved.
//

import UIKit
import AssetsLibrary

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    let libraryPicker = UIImagePickerController()
    let cameraPicker = UIImagePickerController()
    
    var sheetController = UIAlertController(title: "Choose A Photo", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
    var alertController = UIAlertController(title: "Hey", message: "we need permission to open your photos", preferredStyle: UIAlertControllerStyle.Alert)
    
    @IBAction func getPhotoButtonPressed(sender: AnyObject) {
        let authStatus = ALAssetsLibrary.authorizationStatus()
        let needsPermission = !(authStatus == ALAuthorizationStatus.Authorized)
        if (needsPermission) {
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.presentViewController(self.sheetController, animated: true, completion: nil)
        }
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
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        myImageView.image = info[UIImagePickerControllerOriginalImage] as UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}

