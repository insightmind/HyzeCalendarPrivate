//
//  TimeManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 4/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import EventKit

class TimeManagement {
	
	var TMToday = Date()
    
	class func convertToDate(yearID: Int, monthID: Int, dayID: Int) -> Date {
		guard let yearDate = TMCalendar.date(byAdding: .year, value: yearID - 1, to: TMPast, options: .matchStrictly) else {
			return TMPast
		}
		guard let monthDate = TMCalendar.date(byAdding: .month, value: monthID, to: yearDate, options: .matchStrictly) else {
			return yearDate
		}
		guard let date = TMCalendar.date(byAdding: .day, value: dayID, to: monthDate, options: .matchStrictly) else {
			return monthDate
		}
        return date
    }
	
	class func calculateFirstDayInMonth(yearID: Int, monthID: Int) -> Date{
		let date = TimeManagement.convertToDate(yearID: yearID, monthID: monthID, dayID: 1)
		var components = TMCalendar.components([.year, .month], from: date)
		components.day = 2
		let startOfMonth = TMCalendar.date(from: components)!
		print(date)
		print(startOfMonth)
		return startOfMonth
	}
	
	
	class func calculateFirstWeekDayOfMonth(yearID: Int, monthID: Int) -> Int {
		let date = calculateFirstDayInMonth(yearID: yearID, monthID: monthID)
		return TMCalendar.component(.weekday, from: date)
	}
	
	class func getMonthName(_ monthDate: Date) -> String {
        let prestr = monthName[TMCalendar.component(.month, from: monthDate) - 1]
        let poststr = String(TMCalendar.component(.year, from: monthDate))
        let str = "\(prestr) \(poststr)"
		if informationMode {
			print("getMonthName \(monthDate): \(str)")
		}
        return str
    }
	
	class func calculateDaysInMonth(yearID: Int, monthID: Int) -> Int {
		let date = calculateFirstDayInMonth(yearID: yearID, monthID: monthID)
		let numOfDaysInMonth = TMCalendar.range(of: .day, in: .month, for: date).length
		return numOfDaysInMonth
	}
}
