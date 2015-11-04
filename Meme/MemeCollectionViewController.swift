//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by nacho on 3/30/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes:[MemeEntry]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let homeButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme")
        self.navigationItem.rightBarButtonItem = homeButton;
        self.memes = fetchAllMemes()
        self.sortMemes()
    }
    
    var sharedContext:NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedModelContext!
    }
    
    func fetchAllMemes() -> [MemeEntry] {
        
        let fetchRequest = NSFetchRequest(entityName: "MemeEntry")
        var error:NSError? = nil
        
        let resutls: [AnyObject]?
        do {
            resutls = try self.sharedContext.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            resutls = nil
        }
        
        if error != nil {
            print("Can not fetch all Memes: \(error)")
        }
        return resutls as! [MemeEntry]
    }
    
    func sortMemes() {
        self.memes.sortInPlace({(meme1:MemeEntry, meme2:MemeEntry) -> Bool in
            return (meme1.timestamp as Int) > (meme2.timestamp as Int);
        });
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.memes = self.fetchAllMemes()
        self.sortMemes()
        self.collectionView.reloadData();
    }
    
    func createMeme() {
        let memeCreator = self.storyboard?.instantiateViewControllerWithIdentifier("memeCreator") as! MemeCreatorController
        memeCreator.hidesBottomBarWhenPushed = true;
        memeCreator.showButtons = !self.memes.isEmpty
        self.navigationController?.pushViewController(memeCreator, animated: true);
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:MemeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollection", forIndexPath: indexPath) as! MemeCollectionViewCell;
        
        let memeItem = self.memes[indexPath.row];
        cell.setImage(memeItem);
        cell.setText(memeItem);
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memeDetailsVC:MemeDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetails") as! MemeDetailsViewController;
        memeDetailsVC.meme = self.memes[indexPath.row];
        memeDetailsVC.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(memeDetailsVC, animated: true);
    }
}
