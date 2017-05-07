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
	
	let TMPast: Date
	let TMFuture: Date
	var TMToday = TMTime.init(date: Date())
	
    
	init() {
		self.TMPast = Date.distantPast
		self.TMFuture = Date.distantFuture
    }
    
	class func convertToDate(_ indexPath: IndexPath, itemOffset: Int = 1, sectionOffset: Int = 1) -> Date {
        let convDate = Date.distantPast
        guard let d = TMCalendar.date(byAdding: .month, value: indexPath.section + sectionOffset, to: convDate, options: .matchFirst) else {
            if failureMode {
                print("[FAILURE] Could not convert indexPath to Date")
            }
            return Date()
        }
        guard let date = TMCalendar.date(byAdding: .day, value: indexPath.item + itemOffset, to: d, options: .matchFirst) else {
            if failureMode {
                print("[FAILURE] Could not convert indexPath to Date")
            }
            return Date()
        }
		if informationMode {
			print("convertToDate \(indexPath), \(itemOffset), \(sectionOffset): \(date)")
		}
        return date
    }
	
	class func convertToIndexPath(_ date: Date, calendar: NSCalendar) -> IndexPath {
		var indexPath = IndexPath(item: 0, section: 0)
		indexPath.section = calendar.components(.month, from: Date.distantPast, to: date, options: .matchFirst).month!
		indexPath.item = calendar.component(.day, from: date)
		if informationMode {
			print("convertToIndexPath \(date), \(calendar): \(indexPath)")
		}
		return indexPath
	}
	
	class func calculateFirstDayInMonth(of date: Date) -> Date?{
		let fdate = TMCalendar.date(bySettingUnit: .day, value: 1, of: date, options: .matchFirst)
		if informationMode {
			print("calculateFirstDayInMonth \(date): \(String(describing: fdate))")
		}
		return fdate
	}
	
	class func calculateFirstDayInMonth(of indexPath: IndexPath) -> Date?{
		let fdate = TimeManagement.convertToDate(IndexPath(item: 1, section: indexPath.section))
		if informationMode {
			print("calculateFirstDayInMonth \(indexPath): \(String(describing: fdate))")
		}
		return fdate
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
}
