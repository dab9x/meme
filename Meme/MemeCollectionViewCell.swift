//
//  MemeCollectionViewCell.swift
//  Meme
//
//  Created by nacho on 3/31/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    let memeTextAttributes = [
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 12)!,
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        //negative stroke width so that we get the foreground color
        NSStrokeWidthAttributeName: -5.0
    ]
    
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    
    func setImage(meme:MemeEntry) {
        if let img = meme.originalImage {
            self.memeImageView.image = img;
            return;
        }
        self.memeImageView.image = meme.memedImage;
    }
    
    func setText(meme:MemeEntry) {
        if let bottomText = meme.getText(bottomTextID) {
            self.bottomText.defaultTextAttributes = memeTextAttributes;
            self.bottomText.textAlignment = NSTextAlignment.Center;
            self.bottomText.text = bottomText;
        }
        if let topText = meme.getText(topTextID) {
            self.topText.defaultTextAttributes = memeTextAttributes;
            self.topText.textAlignment = NSTextAlignment.Center;
            self.topText.text = topText;
        }
    }
}
