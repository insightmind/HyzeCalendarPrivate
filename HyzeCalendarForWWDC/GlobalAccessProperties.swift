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
var animateDayView: Bool = UserDefaults.standard.bool(forKey: "animateDayView")

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

let PI = CGFloat.pi

var isSettingDefaultCalendar = false
var settingsView: SettingsViewController?

var isAMPM : Bool = UserDefaults.standard.bool(forKey: "IsAMPM")

var eventsColorsOnSelectedDate: [UIColor] = [Color.grey]

func calculateColorsForEventsOnSelectedDay (numberOfEvents : Int) {
    eventsColorsOnSelectedDate = []
    for _ in 0..<numberOfEvents {
        let color = UIColor.randomColor()
        eventsColorsOnSelectedDate.append(color)
    }
}

var selectedETViewCellIndexPath: IndexPath?

var GlobalETView: ETView!

//Declare all Names of Months in a year
let monthName: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

var eventsChange: Bool = false

var viewIsDayView: Bool = false

var renDayView: DayView? = nil
