//
//  EventManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/8/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import EventKit
import UIKit


// Basic class for EventKit implementation and functionality
class EventManagement {
	
	// MARK: - Shared
	
	static let shared = EventManagement()
	
	var ETView: ETView!
	
	//Declare all Names of Months ina year
	let months: [String] = DateFormatter().monthSymbols!
	
	var eventsColorsOnSelectedDate: [UIColor] = [Color.grey]
	var eventInformation = EventEditorEventInformations()
	var selectedEventInformation = EventEditorEventInformations()
    
    //initialize EKEventStore for EventKit usage
    let EMEventStore: EKEventStore!
	var EMCalendar: EKCalendar? = nil
	let userDefaultCalendarIdentifier: String = "LocalHyzeCalendarIdentifier"
    
    //function to convert startTime and endTime from events to an Array of Array of Ints for the EventView
    ///Convert the startTime and endTime of event in ArrayOfEvents to ArrayOfIntArray
    /// - parameter events : array of Events by EventKit
	func convertEventsToTimeArray(_ events: [EKEvent]) -> [String: [Int]] {
        
        //create temporary variable of Dictionary of Array of Int with the eventIdentifier as key
		var eventTimes: [String:[Int]] = [String:[Int]]()
        
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
                
                let startHour = TimeManagement.calendar.component(.hour, from: event.startDate)
                let startMinute = TimeManagement.calendar.component(.minute, from: event.startDate)
                var startTime = (startHour * 60) + startMinute
                
                let endHour = TimeManagement.calendar.component(.hour, from: event.endDate)
                let endMinute = TimeManagement.calendar.component(.minute, from: event.endDate)
                var endTime = (endHour * 60) + endMinute
                
                let moreDays = TimeManagement.calendar.compare(event.startDate, to: event.endDate, toUnitGranularity: .day)
                
                if moreDays == .orderedAscending {
                    let (selectedYearID, selectedMonthID, indexPath) = Selection.shared.selectedDayCellIndex
                    
                    guard let selectedIndexPath = indexPath else {
                        fatalError()
                    }
                    
                    if TimeManagement.calendar.compare(event.startDate, to: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item), toUnitGranularity: .day) == .orderedSame {
                        startTime = (startHour * 60) + startMinute
                        endTime = 1440
                    } else if TimeManagement.calendar.compare(event.endDate, to: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item), toUnitGranularity: .day) == .orderedSame {
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
                
                if Settings.shared.informationMode{
                    print("[INFORMATION] \(startHour * 60) + \(startMinute) = \(startTime)min")
                    print("[INFORMATION] \(endHour * 60) + \(endMinute) = \(endTime)min")
                }
                
                eventTime = [tip,startTime,endTime]
            }
			eventTimes[event.eventIdentifier] = eventTime
        }
        return eventTimes
    }
    
    func getEvents(for date: Date) -> [EKEvent] {
		let predicate = EMEventStore.predicateForEvents(withStart: date, end: date.addingTimeInterval(86399), calendars: nil)
        let events = EMEventStore.events(matching: predicate)
        if Settings.shared.informationMode {
			print("[INFORMATION] Events from \(date) to \(date.addingTimeInterval(86339))")
            print("[INFORMATION] Predicate for Events: \(predicate)")
            print("[INFORMATION] Events: \(events)")
            
        }
        return events
    }
    
    func askForPermission() -> Bool {
		var status = false
        if EKEventStore.authorizationStatus(for: .event) ==  EKAuthorizationStatus.authorized {
        } else {
            EMEventStore.requestAccess(to: .event, completion: {
                (accessGranted: Bool, error: Error?) in
				if accessGranted == true {
					let calendar = EventManagement.shared.getHyzeCalendar()
					if calendar == nil {
						EventManagement.shared.createCalendar()
					}
                    status = true
                }
            })
        }
		return status
    }
	
	func createEvent(from: EventEditorEventInformations) -> EKEvent? {
		
		var event: EKEvent
		
		if let identifier = from.eventIdentifier {
			guard let checkedEvent = EMEventStore.event(withIdentifier: identifier) else {
				return nil
			}
			event = checkedEvent
		} else {
			event = EKEvent(eventStore: EventManagement.shared.EMEventStore)
		}
		if from.startDate < from.endDate && !from.isReadOnly {
			event.title = from.title
			event.calendar = from.calendar ?? getHyzeCalendar()
			event.startDate = from.startDate
			event.endDate = from.endDate
			event.isAllDay = from.isAllDay
			event.notes = from.notes
			if let rule = from.recurrenceRule {
				event.recurrenceRules = [rule]
			} else {
				event.recurrenceRules = nil
			}
			
			switch event.calendar.type {
			case .birthday:
				break
			case .local:
				break
			case .subscription:
				break
			default:
				var attendees = [EKParticipant]()
				
				if let participants = from.participants {
					for i in 0..<participants.count {
						if participants[i].isCurrentUser && participants[i].participantRole == .chair {
							continue
						}
						var email = participants[i].url.absoluteString
						let range = email.startIndex...email.index(email.startIndex, offsetBy: 6)
						email.removeSubrange(range)
						if let participant = createParticipant(email: email) {
							attendees.append(participant)
						}
					}
				}
				event.setValue(attendees, forKey: "attendees")
			}
			

			
		} else {
			return nil
		}
		return event
	}
	
 func createParticipant(email: String) -> EKParticipant? {
		let clazz: AnyClass? = NSClassFromString("EKAttendee")
		if let type = clazz as? NSObject.Type {
			let attendee = type.init()
			attendee.setValue(email, forKey: "emailAddress")
			return attendee as? EKParticipant
		}
		return nil
	}
    
	func addEvent(_ informations: EventEditorEventInformations) {
		guard let event = createEvent(from: informations) else {
			print("Event could not be added")
			return
		}
        do {
            try EMEventStore.save(event, span: .thisEvent, commit: true)
            Settings.shared.eventsChange = true
        } catch {
            print("Event could not be added")
            Settings.shared.eventsChange = false
        }
		self.eventInformation = EventEditorEventInformations()

    }
	
	func getCalendarColor(eventIdentifier: String) -> UIColor? {
		guard let event = EMEventStore.event(withIdentifier: eventIdentifier) else {
			return nil
		}
		return UIColor(cgColor: event.calendar.cgColor)
	}
	

	
	func convertToEventEditorEventInformations(eventIdentifier: String, state: EventEditorState, completion: (() -> Void)? = nil) -> EventEditorEventInformations? {
		
		guard let event = EMEventStore.event(withIdentifier: eventIdentifier) else {
			if let complete = completion {
				complete()
			}
			return nil
		}
		
		let informations = EventEditorEventInformations()
		
		informations.state = state
		informations.startDate = event.startDate
		informations.endDate = event.endDate
		informations.isAllDay = event.isAllDay
		informations.title = event.title
		informations.notes = event.notes
		informations.eventIdentifier = eventIdentifier
		informations.calendar = event.calendar
		informations.participants = event.attendees
		informations.isReadOnly = event.isReadOnly()
		informations.recurrenceRule = event.recurrenceRules?.first
		
		
		if let complete = completion {
			complete()
		}
		
		return informations
	}
	
	func getHyzeCalendar() -> EKCalendar? {
		guard let calendarIdentifier = UserDefaults.standard.string(forKey: userDefaultCalendarIdentifier) else{
			return nil
		}
		guard let calendar = EMEventStore.calendar(withIdentifier: calendarIdentifier) else {
			return nil
		}
		calendar.cgColor = Color.red.cgColor
		EMCalendar = calendar
		return calendar
	}
	
	func createCalendar() {
		var newCalendar = EKCalendar(for: .event, eventStore: self.EMEventStore)
		newCalendar.title = "HYZE Calendar"
		
		let sourcesInEventStore = self.EMEventStore.sources
		
		newCalendar.cgColor = Color.red.cgColor
		
		let iCloudFilteredSources = sourcesInEventStore.filter{ $0.sourceType == .calDAV }
		
		if let iCloudSource = iCloudFilteredSources.first {
			newCalendar.source = iCloudSource
		} else {
			print("Could not add a iCloud Calendar, checking now for local Calendar")
			let localFilteredSources = sourcesInEventStore.filter { $0.sourceType == .local }
			if let localSource = localFilteredSources.first {
				newCalendar.source = localSource
			} else {
				print("Could not add local Calendar, will now use standard Calendar for events")
				guard let calendar = self.EMEventStore.defaultCalendarForNewEvents else {
					print("There is no standard Calendar")
					return
				}
				newCalendar = calendar
			}
		}
		do {
			try self.EMEventStore.saveCalendar(newCalendar, commit: true)
			UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: self.userDefaultCalendarIdentifier)
			self.EMCalendar = newCalendar
		} catch {
			fatalError()
		}

	}
	
	func updateEvent(_ informations: EventEditorEventInformations) -> Bool {
		guard let event = createEvent(from: informations) else {
			print("Event could not be updated")
			return false
		}
		do {
			try EMEventStore.save(event, span: .thisEvent)
			Settings.shared.eventsChange = true
			self.eventInformation = informations
			return true
		} catch {
			print("Event could not be updated")
			Settings.shared.eventsChange = false
			return false
		}
		
	}
	
	func deleteEvent(_ informations: EventEditorEventInformations) {
		guard let identifier = informations.eventIdentifier else {
			print("Could not remove event")
			return
		}
		guard let event = EMEventStore.event(withIdentifier: identifier) else {
			print("Could not remove event")
			return
		}
		do {
			try EMEventStore.remove(event, span: .thisEvent)
			Settings.shared.eventsChange = true
		} catch {
			print("Could not remove event")
			Settings.shared.eventsChange = false
		}
		self.eventInformation = EventEditorEventInformations()
	}
	
	func calculateColorsForEventsOnSelectedDay(numberOfEvents : Int) {
		EventManagement.shared.eventsColorsOnSelectedDate = []
		for _ in 0..<numberOfEvents {
			let color = UIColor.randomColor()
			EventManagement.shared.eventsColorsOnSelectedDate.append(color)
		}
	}
	
	func analyseRule(_ information: EventEditorEventInformations) -> RecurrenceType {
		guard let rule = information.recurrenceRule else { return .none }
		
		var couldBeOther = false
		
		if rule.recurrenceEnd != nil { return .custom }
		if rule.interval != 1 { return .custom }
		if let daysOfTheWeek = rule.daysOfTheWeek {
			if daysOfTheWeek.count == 1 {
				if daysOfTheWeek.first!.dayOfTheWeek.rawValue == 1 {
					couldBeOther = true
				} else {
					return .custom
				}
			} else {
				return .custom
			}
		}
		if rule.daysOfTheMonth != nil { return .custom }
		if rule.daysOfTheYear != nil { return .custom }
		if rule.weeksOfTheYear != nil { return .custom }
		if rule.monthsOfTheYear != nil {
			if !rule.monthsOfTheYear!.isEmpty {
				return .custom
			}
		}
		if let position = rule.setPositions {
			if position.count == 1 && couldBeOther {
				if position.first! != 1 {
					return .custom
				}
			} else {
				return .custom
			}
		}
		
		switch rule.frequency {
		case .daily:
			return .day
		case .weekly:
			return .week
		case .monthly:
			return .month
		case .yearly:
			return .year
		}
	}

    
    init() {
        self.EMEventStore = EKEventStore()
    }
}
