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
		let components = DateComponents(calendar: Calendar.current, timeZone: TimeZone.init(abbreviation: "UTC"), year: yearID, month: monthID + 1, day: dayID + 1)
		let date = TMCalendar.date(from: components)!
		print("CONVERTTODATE: \(yearID):\(monthID)+1:\(dayID)+1|\(date)")
        return date
    }
	
	class func calculateFirstDayInMonth(yearID: Int, monthID: Int) -> Date{
		let date = convertToDate(yearID: yearID, monthID: monthID, dayID: 0)
		return date
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
