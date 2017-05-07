//
//  GlobalAccessProperties.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/6/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import UIKit

let informationMode = false
let debugMode = false
let failureMode = false

var darkMode: Bool = UserDefaults.standard.bool(forKey: "DarkMode")

let CALENDARWHITE = UIColor.white
let CALENDARGREY = UIColor.init(red: 0.251, green: 0.251, blue: 0.251, alpha: 1)
let CALENDARORANGE = UIColor.orange

//Declare MainCalendar
let mainCalendar = (NSCalendar(identifier: .gregorian))!

//Initialize constant Variable for the Date of today
let todaysDate = Date()

let EManagement = EventManagement()


let ePast = Date(timeIntervalSince1970: 0)
//let ePast = (mainCalendar.date(era: (mainCalendar.component(.era , from: todaysDate)), year: (mainCalendar.component(.year , from: todaysDate)) - 250, month: (mainCalendar.component(.month , from: todaysDate)), day: (mainCalendar.component(.day , from: todaysDate)), hour: (mainCalendar.component(.hour , from: todaysDate)), minute: (mainCalendar.component(.minute , from: todaysDate)), second: (mainCalendar.component(.second , from: todaysDate)), nanosecond: (mainCalendar.component(.nanosecond , from: todaysDate))))!
//let ePast = NSDate.distantPast
let eFuture = (mainCalendar.date(era: (mainCalendar.component(.era , from: todaysDate)), year: mainCalendar.component(.year , from: todaysDate) + 250, month: mainCalendar.component(.month , from: todaysDate), day: mainCalendar.component(.day , from: todaysDate), hour: mainCalendar.component(.hour , from: todaysDate), minute: mainCalendar.component(.minute , from: todaysDate), second: mainCalendar.component(.second , from: todaysDate), nanosecond: mainCalendar.component(.nanosecond , from: todaysDate)))!
//let eFuture = NSDate.distantFuture

var todaysIndexPath = IndexPath(item: 0, section: 0)

var firstWeekDayOfMonth: Int = 0

var firstDayOfTodaysMonth = mainCalendar.date(era: mainCalendar.component(.era , from: todaysDate), year: mainCalendar.component(.year , from: todaysDate), month: mainCalendar.component(.month , from: todaysDate), day: 1, hour: mainCalendar.component(.hour , from: todaysDate), minute: mainCalendar.component(.minute , from: todaysDate), second: mainCalendar.component(.second , from: todaysDate), nanosecond: mainCalendar.component(.nanosecond , from: todaysDate))

var selectedCellDayString: String = String(mainCalendar.component(.day, from: todaysDate))

var selectedDay: Date = todaysDate

var isSelectedDayToday: Bool = true

var selectedCellMonthInt = todaysIndexPath.section % 12

var selectedCellIndexPath = IndexPath(item: todaysIndexPath.item - 2, section: todaysIndexPath.section)

var loaded = true
var hourDecorationPosition = [[CGFloat]]()

let PI = CGFloat.pi

var isAMPM : Bool = UserDefaults.standard.bool(forKey: "IsAMPM")

var eventsColorsOnSelectedDate: [UIColor] = [CALENDARGREY]

func calculateColorsForEventsOnSelectedDay (numberOfEvents : Int) {
    eventsColorsOnSelectedDate = []
    for _ in 0..<numberOfEvents {
        let color = UIColor.randomColor()
        eventsColorsOnSelectedDate.append(color)
    }
}

var selectedEventsTableViewCellIndexPath: IndexPath?

//Declare all Names of Months in a year
let monthName: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

//Initialize Variable for Range of Days in the prepared Month
var rangeOfDaysInMonth: Int = 0

//Initialize Variable for the first Date of the prepared Month
var firstDayOfMonth = todaysDate

var eventsChange: Bool = false

var viewIsDayView: Bool = false

var renDayView: dayView? = nil

func reloadTodaysIndexPath(){
    let firstWeekDayOfTodaysMonth = mainCalendar.component(.weekday, from: firstDayOfTodaysMonth!)
    todaysIndexPath = IndexPath(item: mainCalendar.component(.day, from: todaysDate) + firstWeekDayOfTodaysMonth - 2, section: mainCalendar.components(.month, from: ePast, to: todaysDate, options: .matchLast).month!)
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

func timeNowRadiant() -> Int {
    let hour = mainCalendar.component(.hour, from: Date())
    let minute = mainCalendar.component(.minute, from: Date())
    return ( (hour * 60) + minute )
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
