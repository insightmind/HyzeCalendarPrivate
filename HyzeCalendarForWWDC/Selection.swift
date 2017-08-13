//
//  Selection.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 4/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

//MARK: - Imports
import Foundation

enum WeekDay: Int {
	case sunday = 0
	case monday = 1
	case tuesday = 2
	case wednesday = 3
	case thursday = 4
	case friday = 5
	case saturday = 6
}


//MARK: -
/// Basic struct for selected Items, mainly for global access
struct Selection {
    
    //MARK: - Variables
    /// Data for the current selected Day in the MonthView
    /// (YearID: Int, MonthID: Int, indexPath in MonthView: IndexPath?)
    var selectedDayCellIndex: (Int, Int, IndexPath?)
	
	/// information if the selected Day is at weekend
	var selectedIsOnWeekend: Bool?
	
	/// information if the selected Day is today
	var selectedIsToday: Bool? = true
    
    /// Data for the current Day in the MonthView
    /// (YearID: Int, MonthID: Int, indexPath in MonthView: IndexPath?)
    var todaysDayCellIndex: (Int, Int, IndexPath?)
    
    ///current yearID of the presented MainCollectionView in CalendarView
	var currentYearID: Int = 0
    
    /// current monthID of the presented MonthCollectionView in CalendarView
	var currentMonthID: Int = 0
    
    /// used to get the yearID of today in TimeManagement
	var todaysYearID: Int = 0
    /// used to get the month of today in TimeManagement
	var todaysMonthID: Int = 0
    /// used to get the dayID of today in TimeManagement
	var todaysDayID: Int = 0
	/// used to set the first weekDay of the calendarView: Default is Sunday => Week starts at sunday
	var weekDayStart: WeekDay = WeekDay.sunday
    
    //MARK: - Initializer
    /// Initializer to set the data of the selection at the start of the app to the data provided by Date()
    init() {
        
        //Calculation of basic data
        let date = Date()
        let yearID = TMCalendar.component(.year, from: date)
        let monthID = TMCalendar.component(.month, from: date)
		let dayID = TMCalendar.component(.day, from: date)
        let dayIndexPath = IndexPath(item: dayID, section: 0)
		
		// Get safely UserDefault for firstWeekDayOfWeek
		weekDayStart = WeekDay(rawValue: UserDefaults.standard.integer(forKey: "firstWeekDayOfWeek")) ?? WeekDay.sunday
        
        // Assign calculated data to the variable
		selectedIsOnWeekend = false
        todaysDayCellIndex = (yearID, monthID, dayIndexPath)
        selectedDayCellIndex = todaysDayCellIndex
    }
	
}
