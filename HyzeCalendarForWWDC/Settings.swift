//
//  Settings.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/31/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import UIKit

enum ReloadType {
    case none
    case calendarView
    case list
    case all
}

class Settings {
	
	// MARK: - Shared
	
	static let shared = Settings()
	
	// MARK: - Variables
	
	// MARK: General
    
    var isDarkMode: Bool {
        set { self.isDarkMode = UserDefaults.standard.bool(forKey: "DarkMode") }
        get { return UserDefaults.standard.bool(forKey: "DarkMode") }
    }
    var showLinesInCalendarView: Bool {
        set { self.isDarkMode = UserDefaults.standard.bool(forKey: "showLinesInCalendarView") }
        get { return UserDefaults.standard.bool(forKey: "showLinesInCalendarView") }
    }
    var animateDayView: Bool {
        set { self.isDarkMode = UserDefaults.standard.bool(forKey: "animateDayView") }
        get { return UserDefaults.standard.bool(forKey: "animateDayView") }
    }
    var isAMPM : Bool {
        set { self.isDarkMode = UserDefaults.standard.bool(forKey: "IsAMPM") }
        get { return UserDefaults.standard.bool(forKey: "IsAMPM") }
    }
    var showWeekNumber: Bool {
        set { self.isDarkMode = UserDefaults.standard.bool(forKey: "showWeekNumber") }
        get { return UserDefaults.standard.bool(forKey: "showWeekNumber") }
    }
    var isFirstBoot: Bool {
        set { self.isDarkMode = UserDefaults.standard.bool(forKey: "isFirstBoot") }
        get { return UserDefaults.standard.bool(forKey: "isFirstBoot") }
    }
    
    var showWatchHands: Bool {
        set { self.isDarkMode = UserDefaults.standard.bool(forKey: "showWatchHands") }
        get { return UserDefaults.standard.bool(forKey: "showWatchHands") }
    }
   
    // MARK: CalendarView
    var lastRowIsNecessary: Bool = true
    
    // MARK: EventList
    var isEventListRelative: Bool = UserDefaults.standard.bool(forKey: "isEventListRelative") {
        didSet {
            UserDefaults.standard.set(isEventListRelative, forKey: "isEventListRelative")
        }
    }
	
	// MARK: Interaction
	var needsDesignUpdate: ReloadType = .calendarView
	var loaded = true
	var hourDecorationPosition = [[CGFloat]]()
	
	var isSettingDefaultCalendar = false
	
	var eventsChange: Bool = false
	var viewIsDayView: Bool = false
	var renDayView: DayView? = nil
    var eventList: EventListTableViewController? = nil
	
	
	// MARK: DEBUG
	let informationMode = false
	let debugMode = false
	let failureMode = false
	
	
}
