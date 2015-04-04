//
//  MemeTableCell.swift
//  Meme
//
//  Created by nacho on 4/3/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit

class MemeTableCell: UITableViewCell {
    
    func setImage(meme:MemeEntry) {
        self.imageView?.image = meme.memedImage;
        self.imageView?.frame = CGRectMake(0, 0, 30, 30)
        self.imageView?.contentMode = UIViewContentMode.ScaleToFill
    }
    
    func setText(meme:MemeEntry) {
        self.textLabel?.frame.origin.x = 30
        self.textLabel?.frame.origin.y = 30
        if let topText = meme.textFields[MemeEntry.topTextID] {
            self.textLabel?.text = topText;
            return;
        }
        if let bottomText = meme.textFields[MemeEntry.bottomTextID] {
            self.textLabel?.text = bottomText;
            return;
        }
    }
}
