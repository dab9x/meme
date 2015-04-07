//
//  MemeDetailsViewController.swift
//  Meme
//
//  Created by nacho on 3/31/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme:MemeEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme");
        var deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMeme");
        self.navigationItem.rightBarButtonItems = [deleteButton, editButton];
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = self.meme.memedImage;
    }
    
    func editMeme() {
        var memeCreatorVC = self.storyboard?.instantiateViewControllerWithIdentifier("memeCreator") as MemeCreatorController;
        memeCreatorVC.meme = self.meme;
        self.navigationController?.pushViewController(memeCreatorVC, animated: true);
    }
    
    func deleteMeme() {
        getDelegate().deleteMeme(self.meme);
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func getDelegate() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate;
        let appDelegate = object as AppDelegate;
        return appDelegate;
    }
}
