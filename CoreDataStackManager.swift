//
//  CoreDataStackManager.swift
//  Meme
//
//  Created by nacho on 5/25/15.
//  Copyright (c) 2015 Ignacio Moreno. All rights reserved.
//

import Foundation
import CoreData

private let SQLITE_FILE_NAME = "Memes.sqlite"

class CoreDataStackManager {
    
    class func sharedInstance() -> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
        return Static.instance
    }
    
    lazy var applicationsDocumentsDirectory:NSURL = {
        let url = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as! NSURL
        return url
    }()
    
    lazy var managedModelObject: NSManagedObjectModel = {
        let modelUrl = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelUrl)!
    }()
    
    lazy var persistenceStoreCoordinator:NSPersistentStoreCoordinator? = {
        var coordinator:NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedModelObject);
        let url = self.applicationsDocumentsDirectory.URLByAppendingPathComponent(SQLITE_FILE_NAME)
        
        println("sqlite path: \(url.path!)")
        
        var error:NSError? = nil
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "MEME_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            
            // Left in for development development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedModelContext: NSManagedObjectContext? = {
        
        let coordinator = self.persistenceStoreCoordinator
        if coordinator == nil {
            return nil
        }
        let managedObjectContext = NSManagedObjectContext();
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func saveContext() {
        if let context = self.managedModelContext {
            var error:NSError? = nil
            
            if context.hasChanges && !context.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
}
