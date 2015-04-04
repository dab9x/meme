//
//  MemeTableViewController.swift
//  Meme
//
//  Created by nacho on 3/30/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes:[MemeEntry]!
    private var first:Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.parentViewController?.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme");
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        getMemesFromDelegate();
        if (self.first) {
            self.createMeme();
        } else {
            self.parentViewController?.title = "Sent Memes";
        }
    }
    
    func isEmtpyMeme() -> Bool {
        return self.memes.isEmpty
    }
    
    func getMemesFromDelegate() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        self.memes = appDelegate.memes
    }
    
    func createMeme() {
        self.parentViewController?.title = "";
        self.first = false;
        self.parentViewController?.navigationController?.performSegueWithIdentifier("memeCreatorSegue", sender: self);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memes = self.memes {
            return memes.count;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MemeTableCell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath) as MemeTableCell;
        
        var memeItem = self.memes[indexPath.row];
        cell.setText(memeItem);
        cell.setImage(memeItem);
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var memeDetailsVC:MemeDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetails") as MemeDetailsViewController;
        memeDetailsVC.meme = self.memes[indexPath.row];
        self.navigationController?.pushViewController(memeDetailsVC, animated: true);
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110;
    }
}
