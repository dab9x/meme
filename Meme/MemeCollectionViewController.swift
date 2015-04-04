//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by nacho on 3/30/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes:[MemeEntry]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var homeButton : UIBarButtonItem = UIBarButtonItem(title: "New", style: UIBarButtonItemStyle.Plain, target: self, action: "createMeme")
        self.parentViewController?.navigationItem.rightBarButtonItem = homeButton;
        getMemesFromDelegate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        getMemesFromDelegate();
        self.collectionView.reloadData();
    }
    
    func createMeme() {
        self.parentViewController?.navigationController?.performSegueWithIdentifier("memeCreatorSegue", sender: self);
    }
    
    func getMemesFromDelegate() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        self.memes = appDelegate.memes
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:MemeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollection", forIndexPath: indexPath) as MemeCollectionViewCell;
        
        var memeItem = self.memes[indexPath.row];
        cell.setImage(memeItem);
        cell.setText(memeItem);
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var memeDetailsVC:MemeDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetails") as MemeDetailsViewController;
        memeDetailsVC.meme = self.memes[indexPath.row];
        self.navigationController?.pushViewController(memeDetailsVC, animated: true);
    }
}
