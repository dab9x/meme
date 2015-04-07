//
//  MemeCreatorController.swift
//  Image Picker
//
//  Created by nacho on 3/28/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit

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
    
    let memeTextAttributes = [
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        //negative stroke width so that we get the foreground color
        NSStrokeWidthAttributeName: -5.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera);
        initializeMemeEntry();
        setupText(topText, key: topTextID);
        setupText(bottomText, key: bottomTextID);
    }
    
    func initializeMemeEntry() {
        if (self.meme == nil) {
            var timestamp = UInt64(floor(NSDate().timeIntervalSince1970 * 1000));
            self.meme = MemeEntry(textFields: [topTextID: "", bottomTextID: ""], originalImage: nil, memedImage: nil, timestamp: timestamp);
        } else {
            if let top = self.meme.textFields[topTextID] {
                self.topText.text = top;
            }
            if let bottom = self.meme.textFields[bottomTextID] {
                self.bottomText.text = bottom;
            }
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
        self.navigationItem.rightBarButtonItem?.enabled = !getAppDelegate().memes.isEmpty;
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "share");
        // if we are editing set the image scale to fit
        if let img = imageView.image {
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.topText.hidden = false;
        self.bottomText.hidden = false;
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var currentValue:String = self.meme.textFields[textField.restorationIdentifier!]!;
        
        if (currentValue.isEmpty) {
            textField.text = "";
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.meme.textFields[textField.restorationIdentifier!] = textField.text;
        if let currentValue = self.meme.textFields[textField.restorationIdentifier!] {
            if (currentValue.isEmpty) {
                textField.text = defaultValues[textField.restorationIdentifier!];
            }
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
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue;
        return keyboardSize.CGRectValue().height
    }
    
    func share() {
        if (self.imageView.image == nil) {
            return;
        }
        self.meme.originalImage = imageView.image;
        var item:UIImage! = generateMemedImage();
        let activityVC = UIActivityViewController(activityItems: [item], applicationActivities: nil);
        //support ios 7... How to support the latest version completionWithItemsHandler
        activityVC.completionHandler = { (activityType:String!, completed:Bool) -> Void in
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
        if(!self.topText.text.isEmpty) {
            self.meme.textFields[topTextID] = self.topText.text;
        }
        if (!self.bottomText.text.isEmpty) {
            self.meme.textFields[bottomTextID] = self.bottomText.text;
        }
        
        getAppDelegate().addMeme(meme);
        self.close();
    }
    
    func getAppDelegate() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate;
        let appDelegate = object as AppDelegate;
        return appDelegate;
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
        var topText:String = self.meme.textFields[topTextID]!;
        var bottomText:String = self.meme.textFields[bottomTextID]!;
        if (topText.isEmpty) {
            self.topText.hidden = hidden;
        }
        if (bottomText.isEmpty) {
            self.bottomText.hidden = hidden;
        }
    }
}

