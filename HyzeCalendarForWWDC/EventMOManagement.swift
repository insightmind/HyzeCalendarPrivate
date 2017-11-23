//
//  EventMOManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 21.11.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import EventKit

class EventMOManagement: CoreDataManagement {
    
    class func fetchEventModel(identifier: String) -> EventMO? {
        guard let managedContext = loadManagedContext() else { return nil }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "event == %@", identifier)
        
        do {
            let events = try managedContext.fetch(fetchRequest) as? [EventMO]
            return events?.first
        } catch {
            print("Failed to fetch Event: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func getColor(_ event: EventMO) -> UIColor? {
        guard let color = event.color else { return nil }
        guard let unarchivedColor = NSKeyedUnarchiver.unarchiveObject(with: color) as? UIColor else { return nil }
        return unarchivedColor
    }
    
    class func updateEventModel(_ informations: EventEditorEventInformations, event: EKEvent, managedContext: NSManagedObjectContext) {
        guard let identifier = event.eventIdentifier else { return }
        if let existingCoreEvent = EventMOManagement.fetchEventModel(identifier: identifier) {
            let encodedColor = NSKeyedArchiver.archivedData(withRootObject: informations.color)
            existingCoreEvent.color = encodedColor
            return
        } else {
            let coreEvent = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedContext) as! EventMO
            coreEvent.event = identifier
            let encodedColor = NSKeyedArchiver.archivedData(withRootObject: informations.color)
            coreEvent.color = encodedColor
        }
    }
    
}
