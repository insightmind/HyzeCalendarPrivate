//
//  EventRecurrenceInformation.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/23/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import EventKit

struct EventRecurrenceInformation {
	var recurrenceEnd: EKRecurrenceEnd?
	var frequency: EKRecurrenceFrequency
	var interval: Int
	var firstDayOfTheWeek: Int
	var daysOfTheWeek: [EKRecurrenceDayOfWeek]?
	var daysOfTheMonth: [NSNumber]?
	var daysOfTheYear: [NSNumber]?
	var weeksOfTheYear: [NSNumber]?
	var monthsOfTheYear: [NSNumber]?
	var setPositions: [NSNumber]?
	
	init(frequency: EKRecurrenceFrequency, interval: Int, firstDayOfTheWeek: Int) {
		self.frequency = frequency
		self.interval = interval
		self.firstDayOfTheWeek = firstDayOfTheWeek
	}
}
