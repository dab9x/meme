//
//  MemeDetailsViewController.swift
//  Meme
//
//  Created by nacho on 3/31/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme:MemeEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme");
        var deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMeme");
        self.navigationItem.rightBarButtonItems = [deleteButton, editButton];
    }
    
    var sharedContext:NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedModelContext!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = self.meme.memedImage;
    }
    
    func editMeme() {
        var memeCreatorVC = self.storyboard?.instantiateViewControllerWithIdentifier("memeCreator") as! MemeCreatorController;
        memeCreatorVC.meme = self.meme;
        self.navigationController?.pushViewController(memeCreatorVC, animated: true);
    }
    
    func deleteMeme() {
        self.sharedContext.deleteObject(self.meme)
        CoreDataStackManager.sharedInstance().saveContext()
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func getDelegate() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate;
        let appDelegate = object as! AppDelegate;
        return appDelegate;
    }
}
