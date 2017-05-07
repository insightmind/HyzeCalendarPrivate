//
//  ViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//


import UIKit
import CoreGraphics

class ViewController: UIViewController {
    
    var load = 1
    var darkModeTemp: Bool!
    var isAMPMTemp: Bool!

    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarview: CalendarView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var selectedDayButton: UIBarButtonItem!
    @IBOutlet weak var eventTableView: EventTableView!
    @IBOutlet weak var toolbar: UIToolbar!

    //Outlets of DaysOfWeek
    @IBOutlet weak var FirstDayOfWeek: UILabel!
    @IBOutlet weak var SecondDayOfWeek: UILabel!
    @IBOutlet weak var ThirdDayOfWeek: UILabel!
    @IBOutlet weak var FourthDayOfWeek: UILabel!
    @IBOutlet weak var FivthDayOfWeek: UILabel!
    @IBOutlet weak var SixthDayOfWeek: UILabel!
    @IBOutlet weak var SeventhDayOfWeek: UILabel!
    let daysOfWeek: [UILabel]? = nil

    
    
    @IBAction func jumpToToday(_ sender: UIBarButtonItem) {
        
        
        if isSelectedDayToday != true {
            if calendarview.visibleMonth == todaysIndexPath.section {
                if informationMode {
                    print("jumpToToday todaysIndexPath:\(todaysIndexPath)")
                }
                guard let todaysCell = calendarview.cellForItem(at: todaysIndexPath) as? CalendarViewCell else {
                    if failureMode {
                        print("[FAILURE] There is no cell for today")
                    }
                    return
                }
                calendarview.visualDeselectCell(calendarview)
                calendarview.visualSelectCell(todaysCell, isToday: true)
                selectedCellIndexPath = IndexPath(item: todaysIndexPath.item, section: todaysIndexPath.section)
            
            } else {
                selectedCellIndexPath = IndexPath(item: todaysIndexPath.item, section: todaysIndexPath.section)
            }
            selectedCellDayString = String(mainCalendar.component(.day, from: todaysDate))
            selectedCellMonthInt = todaysIndexPath.section % 12
            isSelectedDayToday = true
            selectedDay = todaysDate
            eventTableView.reloadView()
        }
        calendarview.updateMonth(monthIndex: todaysIndexPath.section)
        calendarview.visibleMonth = todaysIndexPath.section
        navigationBar.title = calendarview.getMonthName(monthDate: todaysDate)
        calendarview.scrollToNextSection(calendarview, monthIndex: calendarview.visibleMonth, animated: true)
        updateSelectedDayIcon()
    }
    
    @IBAction func jumpToSelected(_ sender: UIBarButtonItem) {
        calendarview.updateMonth(monthIndex: selectedCellIndexPath.section)
        calendarview.visibleMonth = selectedCellIndexPath.section
        navigationBar.title = calendarview.getMonthName(monthDate: selectedDay)
        calendarview.scrollToNextSection(calendarview, monthIndex: calendarview.visibleMonth, animated: true)
        updateSelectedDayIcon()
    }

    @IBAction func scrollDown(_ sender: UISwipeGestureRecognizer) {
        calendarview.updateMonthbyCurrentMonth(nextMonth: 1)
        calendarview.visibleMonth = calendarview.visibleMonth + 1
        navigationBar.title = calendarview.getMonthName(monthDate: firstDayOfMonth)
        calendarview.scrollToNextSection(calendarview, monthIndex: calendarview.visibleMonth, animated: true)
        updateSelectedDayIcon()
    }
    @IBAction func scrollUp(_ sender: UISwipeGestureRecognizer) {
        calendarview.updateMonthbyCurrentMonth(nextMonth: -1)
        calendarview.visibleMonth = calendarview.visibleMonth - 1
        navigationBar.title = calendarview.getMonthName(monthDate: firstDayOfMonth)
        calendarview.scrollToNextSection(calendarview, monthIndex: calendarview.visibleMonth, animated: true)
        updateSelectedDayIcon()
    }

    func updateSelectedDayIcon(){
        if calendarview.visibleMonth < selectedCellIndexPath.section {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_down")
        } else if calendarview.visibleMonth > selectedCellIndexPath.section {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_up")
        } else {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_right")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if darkMode{
            view.backgroundColor = CALENDARGREY
            updateDaysOfWeek(color: CALENDARWHITE)
        } else {
            view.backgroundColor = CALENDARWHITE
            updateDaysOfWeek(color: CALENDARGREY)
        }
        if darkModeTemp != darkMode {
            eventTableView.reloadData()
            calendarview.reloadSections(IndexSet(integer: calendarview.visibleMonth))
            darkModeTemp = darkMode
        } else if isAMPMTemp != isAMPM || eventsChange == true {
            eventTableView.reloadData()
            eventTableView.reloadView()
            eventsChange = false
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        darkModeTemp = darkMode
        reloadTodaysIndexPath()
        selectedCellIndexPath = todaysIndexPath
        rangeOfDaysInMonth = mainCalendar.range(of: .day, in: .month, for: todaysDate).length        
        calendarview.updateMonth(monthIndex: todaysIndexPath.section)
        calendarview.visibleMonth = todaysIndexPath.section
        navigationBar.title = calendarview.getMonthName(monthDate: firstDayOfMonth)
        
        calendarview.layoutIfNeeded()
        calendarview.layoutSubviews()
        
        eventTableView.layoutIfNeeded()
        eventTableView.layoutSubviews()
        eventTableView.reloadView()
        
        calendarview.scrollsToTop = false
        
        calendarview.scrollToNextSection(calendarview, monthIndex: todaysIndexPath.section, animated: false)
        
        calendarview.backgroundColor = UIColor.clear
        
        if load == 1 {
            calendarview.reloadData()
            eventTableView.reloadData()
            load = 2
        }
    }

    func updateDaysOfWeek(color: UIColor) {
        FirstDayOfWeek.textColor = color
        SecondDayOfWeek.textColor = color
        ThirdDayOfWeek.textColor = color
        FourthDayOfWeek.textColor = color
        FivthDayOfWeek.textColor = color
        SixthDayOfWeek.textColor = color
        SeventhDayOfWeek.textColor = color
    }
    
    @IBAction func unwindToMonthView(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

