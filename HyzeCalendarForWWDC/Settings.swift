//
//  Settings.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/31/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import UIKit

class Settings {
	
	// MARK: - Shared
	
	static let shared = Settings()
	
	// MARK: - Variables
	
	// MARK: General
	var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "DarkMode")
	var showLinesInCalendarView: Bool = UserDefaults.standard.bool(forKey: "showLinesInCalendarView")
	var animateDayView: Bool = UserDefaults.standard.bool(forKey: "animateDayView")
	var isAMPM : Bool = UserDefaults.standard.bool(forKey: "IsAMPM")
    var showWeekNumber: Bool = UserDefaults.standard.bool(forKey: "showWeekNumber")
    let isFirstBoot: Bool = UserDefaults.standard.bool(forKey: "isFirstBoot")
   
    // MARK: CalendarView
    var lastRowIsNecessary: Bool = true
    
    // MARK: EventList
    var isEventListRelative: Bool = UserDefaults.standard.bool(forKey: "isEventListRelative") {
        didSet {
            UserDefaults.standard.set(isEventListRelative, forKey: "isEventListRelative")
        }
    }
	
	// MARK: Interaction
	var needsDesignUpdate: Bool = false
	var loaded = true
	var hourDecorationPosition = [[CGFloat]]()
	
	var isSettingDefaultCalendar = false
	
	var eventsChange: Bool = false
	var viewIsDayView: Bool = false
	var renDayView: DayView? = nil
	
	
	// MARK: DEBUG
	let informationMode = false
	let debugMode = false
	let failureMode = false
	
	
}
