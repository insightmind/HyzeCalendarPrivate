//
//  TimeManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 4/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

//MARK: - Imports
import Foundation
import EventKit

//MARK: -
class TimeManagement {
	
	//MARK: - Calendar
	static var calendar: NSCalendar = {
		let c = NSCalendar(identifier: .gregorian)!
		c.timeZone = NSTimeZone.system
		return c
	}()
	
	static let past = Date.distantPast
	static let future = Date.distantFuture
    
    //MARK: - Global Functions
    
    /// Converts given data to a Date
    ///
    /// - Parameters:
    ///   - yearID: yearID of the date in the CalendarView
    ///   - monthID: monthID of the date in the CalendarView
    ///   - dayID: dayID of the date in the CalendarView
    /// - Returns: Date from the given Input
	class func convertToDate(yearID: Int, monthID: Int, dayID: Int, timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Date {
        
        // Creating DateComponents of the given IDs, incrementing monthID by 1 because Month begins in CalendarView by 0
		let components = DateComponents(calendar: Calendar.current, timeZone: timeZone, year: yearID, month: monthID, day: dayID)
		
		
        // Creating date based of the calculated components
		let date = TimeManagement.calendar.date(from: components)!
        
        // Output informations
        if Settings.shared.informationMode {
            print("CONVERTTODATE: \(yearID):\(monthID):\(dayID)|\(date)")
        }
        
        //Return calculated date
        return date
    }
    
    /// calculates the first day in the given month
    ///
    /// - Parameters:
    ///   - yearID: yearID of the month in the CalendarView
    ///   - monthID: monthID of the month in the CalendarView
    /// - Returns: first day in given month
	class func calculateFirstDayInMonth(yearID: Int, monthID: Int) -> Date{
        
        // Calculate the date by converting the IDs and by setting the dayID to 1
		let date = convertToDate(yearID: yearID, monthID: monthID, dayID: 1, timeZone: TimeZone.init(abbreviation: "GMT")!)
        
        // Return calculated date
		return date
	}
	
	
    /// Calulates the weekday of the first day in the given month
    ///
    /// - Parameters:
    ///   - yearID: yearID of the given month in CalendarView
    ///   - monthID: monthID of the given month in CalendarView
    /// - Returns: weekday of the first date in the given month
	class func calculateFirstWeekDayOfMonth(yearID: Int, monthID: Int) -> Int {
        
        // calculate the firstDay of the Month
		let date = calculateFirstDayInMonth(yearID: yearID, monthID: monthID)
        
        // return the weekdayComponent of the firstDay and decrement it by 1 so Mon == 0
		return TimeManagement.calendar.component(.weekday, from: date)
	}
    
    /// Get the MonthName + YearName of the given date
    ///
    /// - Parameter monthDate: Any date in the month
    /// - Returns: name of the month and year as string
	class func getMonthName(_ monthDate: Date, withYear: Bool = true) -> String {
		
		//get the Index of the month
		let month = TimeManagement.calendar.component(.month, from: monthDate) - 1
        
        // Get the EventManagement.shared.months with the Index of the month
        let prestr = EventManagement.shared.months[month]
		
		// Add both strings to one
		let str: String
		
		if withYear {
			// Get the yearName by getting the YearComponent of the given date
			let poststr = String(TimeManagement.calendar.component(.year, from: monthDate))
			
			str = "\(prestr) \(poststr)"
			
		} else {
			str = prestr
		}
        
        // Output information
		if Settings.shared.informationMode {
			print("getMonthName \(monthDate): \(str)")
		}
        
        // Return the calculated String
        return str
    }
	
    /// Calculates the number of days in the given month
    ///
    /// - Parameters:
    ///   - yearID: yearID of the given month
    ///   - monthID: monthID of the given month
    /// - Returns: number of days in the given month
	class func calculateDaysInMonth(yearID: Int, monthID: Int) -> Int {
        
        // Get any date in the month, preferred the firstDay, because it is already setUp
		let date = calculateFirstDayInMonth(yearID: yearID, monthID: monthID)
        
        // Get the number of days in the month using the calculated day
		let numOfDaysInMonth = TimeManagement.calendar.range(of: .day, in: .month, for: date).length
        
        // Return the number of days in the month
		return numOfDaysInMonth
	}
	
	
	
	/// Checks if the given Cell or Date is the same as the todaysDate
	///
	/// - Parameters:
	///   - yearID: yearID of the comparable Date or Cell
	///   - monthID: monthID of the comparable Date or Cell
	///   - dayID: dayID of the comparable Date or Cell
	/// - Returns: a boolean indicating if both dates are the same
	class func isToday(yearID: Int, monthID: Int, dayID: Int) -> Bool {
		
		let todaysDay = (Selection.shared.todaysDayID, Selection.shared.todaysMonthID, Selection.shared.todaysYearID)
		let compareDay = (dayID, monthID, yearID)
		
		return todaysDay == compareDay
		
	}
    
    class func getWeekNumber(yearID: Int, monthID: Int, dayID: Int) -> Int {
        
        let date = convertToDate(yearID: yearID, monthID: monthID, dayID: dayID)
        return TimeManagement.calendar.component(.weekOfYear, from: date)
        
    }
    
    class func getTimeInMinutes(of date: Date) -> Int {
        let hour = TimeManagement.calendar.component(.hour, from: date)
        let minute = TimeManagement.calendar.component(.minute, from: date)
        let time = (hour * 60) + minute
        return time
    }
	
	/// Checks if Cell is same as selectedCell
	///
	/// - Parameters:
	///   - yearID: yearID of the comparable Date or Cell
	///   - monthID: monthID of the comparable Date or Cell
	///   - dayID: dayID of the comparable Date or Cell
	/// - Returns: a boolean indicating if both cells are the same
	class func isSelected(yearID: Int, monthID: Int, dayID: Int) -> Bool {
        let (selectedYearID, selectedMonthID, indexPath) = Selection.shared.selectedDayCellIndex
        guard let selectedIndexPath = indexPath else {
            return false
        }
		let selectedDay = (selectedIndexPath.item, selectedMonthID, selectedYearID)
		let compareDay = (dayID, monthID, yearID)
		
		return selectedDay == compareDay
	}
	
	
	class func timeRadiant(_ date: Date) -> CGFloat {
		let hour = TimeManagement.calendar.component(.hour, from: date)
		let minute = TimeManagement.calendar.component(.minute, from: date)
		let timeInMinute = CGFloat((hour * 60) + minute )
		let angle = ((timeInMinute * CGFloat.pi)/720)
		return angle
	}
}
