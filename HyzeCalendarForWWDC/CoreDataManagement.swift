//
//  CoreDataManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 21.11.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManagement {
    
    class func loadManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func save(managedContext: NSManagedObjectContext) {
        do {
            try managedContext.save()
        } catch {
            print("Could not save ManagedContext: \(error.localizedDescription)")
        }
    }
    
}
