//
//  TMIndexPath.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 4/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation

struct TMTime {
	
	//MARK: Constants
	
	let firstDay: Date
	let dayOffset: Int
	let monthRange: Int
	
	//MARK: Variables
	
	var monthID: Int
	var dayID: Int
	
	var dayOffID: Int
	
	//MARK: Initializers
	
	init(_ indexPath: IndexPath) {
		self.monthID = indexPath.section
		self.dayID = indexPath.item
		
		self.firstDay = TimeManagement.calculateFirstDayInMonth(of: indexPath)!
		
		self.dayOffset = TMCalendar.component(.weekday, from: self.firstDay)
		self.dayOffID = self.dayID - self.dayOffset + 1
		
		self.monthRange = TMCalendar.range(of: .day, in: .month, for: self.firstDay).length
		
		if informationMode {
			print("init(_ indexPath: IndexPath) \(indexPath): \(monthID), \(dayID), \(firstDay), \(dayOffset), \(dayOffID), \(monthRange)")
		}
	}
	
	init(date: Date) {
		self.init(TimeManagement.convertToIndexPath(date, calendar: TMCalendar))
	}
	
	//MARK: Conformers
	
	func conformToIndexPath() -> IndexPath {
		if informationMode {
			print("func conformToIndexPath() -> IndexPath")
		}
		return IndexPath(item: dayID, section: monthID)
	}
	
	func conformToDate() -> Date {
		if informationMode {
			print("func conformToDate() -> Date")
		}
		let indexPath = self.conformToIndexPath()
		
		return TimeManagement.convertToDate(indexPath, itemOffset: 0, sectionOffset: 0)
	}
	
	//MARK: Functions
	
}
