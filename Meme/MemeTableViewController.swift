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
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme");
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        //Load the sent memes from the app delegate that will be displayed
        getMemesFromDelegate();
        //If it is the first time we are loading the view it will not contain any sent memes
        //go to create meme
        if (self.first) {
            self.createMeme();
        } else {
            self.table.reloadData();
        }
    }
    
    func isEmtpyMeme() -> Bool {
        return self.memes.isEmpty
    }
    
    func getMemesFromDelegate() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        appDelegate.sortMemes();
        self.memes = appDelegate.memes
    }
    
    func createMeme() {
        self.first = false;
        var memeCreator = self.storyboard?.instantiateViewControllerWithIdentifier("memeCreator") as MemeCreatorController
        memeCreator.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(memeCreator, animated: true);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memes = self.memes {
            return memes.count;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath) as UITableViewCell;
        var memeItem = self.memes[indexPath.row];
        
        if let top = memeItem.getTopText() {
            cell.textLabel?.text = top;
        }
        
        if let bottom = memeItem.getBottomText() {
            cell.detailTextLabel?.text = bottom;
        }
        cell.imageView?.frame = CGRectMake(0, 0, 50, 50)
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView?.image = memeItem.memedImage;
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var memeDetailsVC:MemeDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetails") as MemeDetailsViewController;
        memeDetailsVC.hidesBottomBarWhenPushed = true;
        memeDetailsVC.meme = self.memes[indexPath.row];
        self.navigationController?.pushViewController(memeDetailsVC, animated: true);
    }
}
