//
//  MemeTableViewController.swift
//  Meme
//
//  Created by nacho on 3/30/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes:[MemeEntry]!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme");
        
        self.memes = self.fetchAllMemes()
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
        //If it is the first time we are loading the view it will not contain any sent memes
        //go to create meme
        if (self.memes.count == 0) {
            self.createMeme();
        } else {
            self.table.reloadData();
        }
    }
    
    func isEmtpyMeme() -> Bool {
        return self.memes.isEmpty
    }
    
    func createMeme() {
        let memeCreator = self.storyboard?.instantiateViewControllerWithIdentifier("memeCreator") as! MemeCreatorController
        memeCreator.hidesBottomBarWhenPushed = true;
        memeCreator.showButtons = !self.memes.isEmpty
        self.navigationController?.pushViewController(memeCreator, animated: true);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memes = self.memes {
            return memes.count;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath) ;
        let memeItem = self.memes[indexPath.row];
        
        if let top = memeItem.top {
            cell.textLabel?.text = top;
        }
        
        if let bottom = memeItem.bottom {
            cell.detailTextLabel?.text = bottom;
        }
        cell.imageView?.frame = CGRectMake(0, 0, 50, 50)
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView?.image = memeItem.memedImage;
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailsVC:MemeDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetails") as! MemeDetailsViewController;
        memeDetailsVC.hidesBottomBarWhenPushed = true;
        memeDetailsVC.meme = self.memes[indexPath.row];
        self.navigationController?.pushViewController(memeDetailsVC, animated: true);
    }
}
