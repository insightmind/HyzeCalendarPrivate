//
//  EventsManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/8/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import EventKit

// Basic class for EventKit implementation and functionality
class EventManagement {
    
    //initialize EKEventStore for EventKit usage
    let EMEventStore: EKEventStore!
    
    //function to convert startTime and endTime from events to an Array of Array of Ints for the EventView
    ///Convert an the startTime and endTime of event in ArrayOfEvents to ArrayOfIntArray
    /// - parameter events : array of Events by EventKit
    func convertEventsToTimeArray(_ events: [EKEvent]) -> [[Int]] {
        
        //create temporary variable of Array of Array of Int
        var eventTimes: [[Int]] = [[Int]]()
        
        //for every event in the eventsArray
        for event in events {
            
            //create temporary IntArray to store collected data
            //eventTime: [EventType,StartTime,EndTime]
            var eventTime: [Int]!
            
            //check if the events duration is all day long
            if event.isAllDay {
                //set eventTime to EventType: allDay = 0, StartTime: 0min and EndTime: 1440 min
                eventTime = [0,0,1440]

            } else {
                var tip = 1
                
                let startHour = mainCalendar.component(.hour, from: event.startDate)
                let startMinute = mainCalendar.component(.minute, from: event.startDate)
                var startTime = (startHour * 60) + startMinute
                
                let endHour = mainCalendar.component(.hour, from: event.endDate)
                let endMinute = mainCalendar.component(.minute, from: event.endDate)
                var endTime = (endHour * 60) + endMinute
                
                let moreDays = mainCalendar.compare(event.startDate, to: event.endDate, toUnitGranularity: .day)
                
                if moreDays == .orderedAscending {
                    if mainCalendar.compare(event.startDate, to: selectedDay, toUnitGranularity: .day) == .orderedSame {
                        startTime = (startHour * 60) + startMinute
                        endTime = 1440
                    } else if mainCalendar.compare(event.endDate, to: selectedDay, toUnitGranularity: .day) == .orderedSame {
                        startTime = 0
                        endTime = (endHour * 60) + endMinute
                    } else {
                        startTime = 0
                        endTime = 1440
                        tip = 0
                    }
                } else {
                    startTime = (startHour * 60) + startMinute
                    endTime = (endHour * 60) + endMinute
                }
                
                if informationMode{
                    print("[INFORMATION] \(startHour * 60) + \(startMinute) = \(startTime)min")
                    print("[INFORMATION] \(endHour * 60) + \(endMinute) = \(endTime)min")
                }
                
                eventTime = [tip,startTime,endTime]
            }
            eventTimes.append(eventTime)
        }
        return eventTimes
    }
    
    func getEvents(for date: Date) -> [EKEvent] {
        let cdate = mainCalendar.date(era: mainCalendar.component(.era, from: date), year: mainCalendar.component(.year, from: date), month: mainCalendar.component(.month, from: date), day: mainCalendar.component(.day, from: date), hour: 0, minute: 0, second: 0, nanosecond: 0)!
        let predicate = EMEventStore.predicateForEvents(withStart: cdate, end: cdate.addingTimeInterval(86399), calendars: nil)
        let events = EMEventStore.events(matching: predicate)
        if informationMode {
            print("[INFORMATION] Events from \(cdate) to \(cdate.addingTimeInterval(86339))")
            print("[INFORMATION] Predicate for Events: \(predicate)")
            print("[INFORMATION] Events: \(events)")
            
        }
        return events
    }
    
    func askForPermission(){
        if EKEventStore.authorizationStatus(for: .event) ==  EKAuthorizationStatus.authorized {
        } else {
            EMEventStore.requestAccess(to: .event, completion: {
                (accessGranted: Bool, error: Error?) in
                
                if accessGranted == true {
                    DispatchQueue.main.async(execute: {
                        if informationMode {
                            print("[INFORMATION] allowed Request for CalendarAccess")
                        }
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        if informationMode {
                            print("[INFORMATION] denied Request for CalendarAccess")
                        }
                    })
                }
            })
        }
    }
    
    func addEvent(title: String = "NoEventTitle", from startDate: Date, to endDate: Date) {
        let event = EKEvent(eventStore: EManagement.EMEventStore)
        event.title = title
        event.calendar = EManagement.EMEventStore.defaultCalendarForNewEvents
        if startDate < endDate {
            event.startDate = startDate
            event.endDate = endDate
            event.isAllDay = false
        }
        do {
            try EMEventStore.save(event, span: .thisEvent, commit: true)
            eventsChange = true
        } catch {
            print("Event could not be added")
            eventsChange = false
        }

    }
    
    init() {
        EMEventStore = EKEventStore()
        askForPermission()
    }
}
