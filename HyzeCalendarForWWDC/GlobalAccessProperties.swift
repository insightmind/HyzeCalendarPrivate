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

var needsDesignUpdate: Bool = false

var darkMode: Bool = UserDefaults.standard.bool(forKey: "DarkMode")
var showLinesInCalendarView: Bool = UserDefaults.standard.bool(forKey: "showLinesInCalendarView")
var isMondayFirstWeekday: Bool = UserDefaults.standard.bool(forKey: "isMondayFirstWeekday")

let CALENDARWHITE = UIColor.white
let CALENDARGREY = UIColor.init(red: 0.251, green: 0.251, blue: 0.251, alpha: 1)
let CALENDARORANGE = UIColor.orange
let CALENDARBLUE = UIColor.init(red: 0.204, green: 0.571, blue: 0.901, alpha: 1)
let CALENDARGREEN = UIColor.init(red: 0.415, green: 0.860, blue: 0.427, alpha: 1)

var TMCalendar: NSCalendar = {
	let c = NSCalendar(identifier: .gregorian)!
	
	c.timeZone = NSTimeZone.system
	
	return c
}()


let HTimeManagement = TimeManagement()
let EManagement = EventManagement()
var HSelection = Selection()

let TMPast = Date.distantPast
let TMFuture = Date.distantFuture
var loaded = true
var hourDecorationPosition = [[CGFloat]]()

var eventsTableView: EventTableView?

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

var eventsChange: Bool = false

var viewIsDayView: Bool = false

var renDayView: dayView? = nil

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

func timeNowRadiant() -> Int {
    let hour = TMCalendar.component(.hour, from: Date())
    let minute = TMCalendar.component(.minute, from: Date())
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
