//
//  MemeEntry.swift
//  Image Picker
//
//  Created by nacho on 3/28/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import UIKit;
import CoreData

@objc(MemeEntry)

class MemeEntry: NSManagedObject {
    
    struct Keys {
        static let TOP = "TOP"
        static let BOTTOM = "BOTTOM"
    }
    
    @NSManaged var top:String?
    @NSManaged var bottom:String?
    @NSManaged var timestamp:NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(top:String?, bottom:String?, timestamp:NSNumber, context:NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("MemeEntry", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.top = top
        self.bottom = bottom
        self.timestamp = timestamp
    }
    
    var originalImage:UIImage? {
        get {
            return ImageCache.sharedInstance().imageWithIdentifier("\(self.timestamp).original")
        }
        
        set {
            ImageCache.sharedInstance().storeImage(newValue, withIdentifier: "\(self.timestamp).original")
        }
    }
    
    var memedImage:UIImage? {
        get {
            return ImageCache.sharedInstance().imageWithIdentifier("\(self.timestamp).memed")
        }
        
        set {
            ImageCache.sharedInstance().storeImage(newValue, withIdentifier: "\(self.timestamp).memed")
        }
    }
}
