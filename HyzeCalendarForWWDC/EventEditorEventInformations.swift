//
//  EventEditorEventInformations.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class EventEditorEventInformations: NSCopying {
	
	func copy(with zone: NSZone? = nil) -> Any {
		let informations = EventEditorEventInformations()
		informations.title = title
		informations.isAllDay = isAllDay
		informations.startDate = startDate
		informations.endDate = endDate
		informations.color = color
		informations.notes = notes
		informations.calendar = calendar
		informations.eventIdentifier = eventIdentifier
		informations.state = state
		informations.dateSelectionPopoverState = dateSelectionPopoverState
		informations.eventEditorTableViewController = eventEditorTableViewController
		informations.setCalendarPopoverViewController = setCalendarPopoverViewController
		informations.recurrenceRule = recurrenceRule
		return informations
	}
	
    func setEventInformations(_ information: EventEditorEventInformations, allInformations: Bool = false) {
		self.state = information.state
		self.startDate = information.startDate
		self.endDate = information.endDate
		self.isAllDay = information.isAllDay
		self.notes = information.notes
		self.participants = information.participants
		self.title = information.title
		self.eventIdentifier = information.eventIdentifier
		self.calendar = information.calendar
		self.recurrenceRule = information.recurrenceRule
		if allInformations {
			dateSelectionPopoverState = information.dateSelectionPopoverState
			setCalendarPopoverViewController = information.setCalendarPopoverViewController
			eventEditorTableViewController = information.eventEditorTableViewController
			eventEditor = information.eventEditor
		}
	}
	
	var title: String = "Untitled Event"
	var isAllDay: Bool = false
	var startDate: Date = Date()
	var endDate: Date = Date(timeIntervalSinceNow: -10)
	var color: UIColor = Color.white
	var notes: String? = nil
	var calendar: EKCalendar? = nil
	var participants: [EKParticipant]? = nil
	var isReadOnly: Bool = false
	var recurrenceRule: EKRecurrenceRule? = nil
	var location: String? = nil
	
	
	//only important for EventEditing not creation
	
	var eventIdentifier: String? = nil
	
	//NOT IMPORTANT FOR EVENTCREATION
	var dateSelectionPopoverState: DateSpecification = .startDate
	var state: EventEditorState = .create
	var setCalendarPopoverViewController: SetCalendarPopoverViewController?
	var eventEditorTableViewController: EventEditorTableViewController?
	var eventEditor: EventEditorViewController?
	var isAllContacts: Bool = false
}
