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
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.image = self.meme.memedImage;
    }
}
