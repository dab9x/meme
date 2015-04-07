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
    
    var textFields:[String:String];
    var originalImage:UIImage?;
    var memedImage:UIImage?;
    var timestamp:UInt64?
    
    static func getInitialTextFields(topKey:String, bottomKey:String) -> [String:String] {
        return [topKey : "", bottomKey : ""]
    }
    
    func getText(key:String) -> String? {
        return self.textFields[key];
    }
}
