//
//  MemeCreatorController.swift
//  Image Picker
//
//  Created by nacho on 3/28/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let topTextID = "topText"
let bottomTextID = "bottomText"

class MemeCreatorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let defaultValues = [topTextID : "TOP", bottomTextID : "BOTTOM"]
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    var meme:MemeEntry!;
    var showButtons:Bool = true
    var isEdit:Bool = false
    
    var temporaryContext:NSManagedObjectContext!
    
    let memeTextAttributes = [
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        //negative stroke width so that we get the foreground color
        NSStrokeWidthAttributeName: -5.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        self.temporaryContext.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().managedModelContext!.persistentStoreCoordinator
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera);
        initializeMemeEntry();
        setupText(topText, key: topTextID);
        setupText(bottomText, key: bottomTextID);
    }
    
    func initializeMemeEntry() {
        if (self.meme == nil) {
            let timestamp = Int(floor(NSDate().timeIntervalSince1970 * 1000)) as NSNumber;
            self.meme = MemeEntry(top: nil, bottom:nil, timestamp: timestamp, context: self.temporaryContext);
        } else {
            if let top = self.meme.top {
                self.topText.text = top;
            }
            if let bottom = self.meme.bottom {
                self.bottomText.text = bottom;
            }
            self.isEdit = true
            self.imageView.image = self.meme.originalImage;
        }
    }
    
    func close() {
        self.navigationController?.popToRootViewControllerAnimated(true);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        subscribeToKeyboardNotifications();
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "close");
        self.navigationItem.rightBarButtonItem?.enabled = showButtons;
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "share");
        self.navigationItem.leftBarButtonItem?.enabled = false;
        // if we are editing set the image scale to fit
        if let _ = imageView.image {
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    func setupText(textField:UITextField, key:String) {
        textField.delegate = self
        textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters;
        textField.defaultTextAttributes = memeTextAttributes;
        textField.textAlignment = NSTextAlignment.Center;
        textField.text = defaultValues[key];
        textField.hidden = self.meme.originalImage == nil;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        unsubscribeFromKeyboardNotifications();
    }
    
    @IBAction func pickAnImage() {
        let imagePicker = UIImagePickerController();
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.delegate = self;
        self.presentViewController(imagePicker, animated: true, completion: nil);
    }
    
    @IBAction func pickAnImageFromCamera() {
        let imagePicker = UIImagePickerController();
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
        imagePicker.delegate = self;
        self.presentViewController(imagePicker, animated: true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.topText.hidden = false;
        self.bottomText.hidden = false;
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationItem.leftBarButtonItem!.enabled = true;
            })
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let identifier = textField.restorationIdentifier!
        var currentValue:String? = nil
        if identifier == topTextID {
             currentValue = self.meme.top
        } else {
            currentValue = self.meme.bottom
        }
        
        if currentValue == nil || currentValue!.isEmpty {
            textField.text = "";
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let identifier = textField.restorationIdentifier!
        if identifier == topTextID {
            if textField.text!.isEmpty {
                textField.text = defaultValues[topTextID]
            }
            self.meme.top = textField.text
        } else {
            if textField.text!.isEmpty {
                textField.text = defaultValues[bottomTextID]
            }
            self.meme.bottom = textField.text
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil);
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (self.bottomText.isFirstResponder()) {
            self.view.frame.origin.y = 0;
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (self.bottomText.isFirstResponder()) {
            /** Some of the custom keyboards (like swype) can incorrectly report keyboardWillShow method multiple times. We could get bad behaviour if we use self.view.frame.origin.y -= getKeyboardHeight(notification);
                
                http://stackoverflow.com/questions/25874975/cant-get-correct-value-of-keyboard-height-in-ios8
            */
            self.view.frame.origin.y = -getKeyboardHeight(notification);
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo;
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue;
        return keyboardSize.CGRectValue().height
    }
    
    func share() {
        if (self.imageView.image == nil) {
            return;
        }
        self.meme.originalImage = imageView.image;
        let item:UIImage! = generateMemedImage();
        let activityVC = UIActivityViewController(activityItems: [item], applicationActivities: nil);
        //support ios 7... How to support the latest version completionWithItemsHandler
        activityVC.completionHandler = { (activityType:String?, completed:Bool) -> Void in
                if (completed) {
                    self.save(item);
                    self.dismissViewControllerAnimated(true, completion: nil);
                }
            }
        
        self.presentViewController(activityVC, animated: true, completion: nil);
    }
    
    func save(memedImage:UIImage!) {
        self.meme.memedImage = memedImage;
        self.meme.originalImage = imageView.image;
        if(!self.topText.text!.isEmpty) {
            self.meme.top = self.topText.text;
        }
        if (!self.bottomText.text!.isEmpty) {
            self.meme.bottom = self.bottomText.text;
        }
        if (self.isEdit) {
            CoreDataStackManager.sharedInstance().saveContext()
        } else {
            _ = MemeEntry(top: self.meme.top, bottom: self.meme.bottom, timestamp: self.meme.timestamp, context: CoreDataStackManager.sharedInstance().managedModelContext!)
            CoreDataStackManager.sharedInstance().saveContext()
        }
        self.close();
    }
    
    func generateMemedImage() -> UIImage {
        hideElements(true);
        hideText(true);
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideElements(false);
        hideText(false);
        
        return memedImage
    }
    
    func hideElements(hidden:Bool) {
        self.toolBar.hidden = hidden;
        self.navigationController?.navigationBar.hidden = hidden;
    }
    
    func hideText(hidden:Bool) {
        let topText:String = self.meme.top ?? "";
        let bottomText:String = self.meme.bottom ?? "";
        if (topText.isEmpty) {
            self.topText.hidden = hidden;
        }
        if (bottomText.isEmpty) {
            self.bottomText.hidden = hidden;
        }
    }
}

