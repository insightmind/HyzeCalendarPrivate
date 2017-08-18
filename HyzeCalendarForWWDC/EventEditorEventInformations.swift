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

class EventEditorEventInformations {
	var title: String = "Untitled Event"
	var isAllDay: Bool = false
	var startDate: Date = Date()
	var endDate: Date = Date().addingTimeInterval(1800)
	var color: UIColor = Color.white
	var notes: String? = nil
	var calendar: EKCalendar? = nil
	
	
	//only important for EventEditing not creation
	
	var eventIdentifier: String? = nil
	
	//NOT IMPORTANT FOR EVENTCREATION
	var dateSelectionPopoverState: DateSpecification = .startDate
	var state: EventEditorState = .create
	var setCalendarPopoverViewController: SetCalendarPopoverViewController?
	var eventEditorTableViewController: EventEditorTableViewController?
}
