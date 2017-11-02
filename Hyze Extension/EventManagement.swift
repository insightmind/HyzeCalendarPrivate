//
//  EventManagement.swift
//  Hyze Extension
//
//  Created by Niklas Bülow on 30.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import EventKit

enum dayChangeDirection {
    case previous
    case today
    case next
}

class EventManagement {
    
    static let shared = EventManagement()
    
    private let EMEventStore = EKEventStore()
    private var date = Date.today()
    
    func fetch() -> [EKEvent] {
        guard let nextDay = self.date + 1.day else { return [EKEvent]() }
        let predicate = EMEventStore.predicateForEvents(withStart: self.date, end: nextDay, calendars: nil)
        let events = EMEventStore.events(matching: predicate)
        print(events.count)
        return events
    }
    
    func setDay(_ direction: dayChangeDirection) {
        switch direction {
        case .previous:
            guard let day = self.date - 1.day else { return }
            self.date = day
        case .next:
            guard let day = self.date + 1.day else { return }
            self.date = day
        case .today:
            self.date = Date.today()
        }
    }
    
    func getDate() -> Date { return date }
    
    private func askForPermission() -> Bool {
        var status = false
        if EKEventStore.authorizationStatus(for: .event) ==  EKAuthorizationStatus.authorized {
        } else {
            EMEventStore.requestAccess(to: .event, completion: {
                (accessGranted: Bool, error: Error?) in
                status = accessGranted
            })
        }
        return status
    }
}
