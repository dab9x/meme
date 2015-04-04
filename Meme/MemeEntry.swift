//
//  MemeEntry.swift
//  Image Picker
//
//  Created by nacho on 3/28/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit;

struct MemeEntry {
    
    static let topTextID = "topText"
    static let bottomTextID = "bottomText"
    static let defaultValues = [MemeEntry.topTextID : "TOP", MemeEntry.bottomTextID : "BOTTOM"]
    
    var textFields:[String:String];
    var originalImage:UIImage?;
    var memedImage:UIImage?;
    
    static func getInitialTextFields() -> [String:String] {
        return [MemeEntry.topTextID : "", MemeEntry.bottomTextID : ""]
    }
}
