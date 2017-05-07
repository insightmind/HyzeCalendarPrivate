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
	
	init(month: Int, day: Int) {
		self.monthID = month
		self.dayID = day
		
		let date = TimeManagement.convertToDate(IndexPath(item: day, section: month))
		self.firstDay = TimeManagement.calculateFirstDayInMonth(of: date)!
		self.dayOffset = TMCalendar.component(.weekday, from: self.firstDay)
		self.dayOffID = self.dayID - self.dayOffset
		
		self.monthRange = TMCalendar.range(of: .day, in: .month, for: self.firstDay).length
		
		if informationMode {
			print("init(month: Int, day: Int) \(month), \(day): \(monthID), \(dayID), \(firstDay), \(dayOffset), \(dayOffID), \(monthRange)")
		}
	}
	
	init(_ indexPath: IndexPath) {
		self.monthID = indexPath.section
		self.dayID = indexPath.item
		
		let date = TimeManagement.convertToDate(indexPath)
		self.firstDay = TimeManagement.calculateFirstDayInMonth(of: date)!
		self.dayOffset = TMCalendar.component(.weekday, from: self.firstDay)
		self.dayOffID = self.dayID - self.dayOffset
		
		self.monthRange = TMCalendar.range(of: .day, in: .month, for: self.firstDay).length
		if informationMode {
			print("init(_ indexPath: IndexPath) \(indexPath): \(monthID), \(dayID), \(firstDay), \(dayOffset), \(dayOffID), \(monthRange)")
		}
	}
	
	init(date: Date) {
		self.init(TimeManagement.convertToIndexPath(date, calendar: NSCalendar(calendarIdentifier: .gregorian)!))
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
	
}
