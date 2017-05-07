//
//  CalendarViewDataSource.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//


import UIKit
import Foundation

class CalendarView:UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var eventTableView: EventTableView!
    
    @IBOutlet weak var selectedDayButton: UIBarButtonItem!
    
    //MARK: Properties
    //mostly used for UICollectionViewDataSource functions
    
    //ReusableID Declaration for the cells in collectionview representing a day
    let cellReusableID = "daycell"
    let headerReusableID = "monthViewCollectionHeader"
    
    //Declare how many days are in one week
    let DAYS_IN_WEEK = 7
    
    //Declare the maximum number of rows in a section
    let MAX_WEEKS_IN_MONTH: CGFloat = 6.0
    
    //Constant for Size of Cells and Header
    var cellSize: CGSize?
    var headerSize: CGSize?
    
    var times = 0
    
    var visibleMonth : Int = -2
    
    //MARK: Functions
    
    //MARK: DataSourceFunctions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: cellReusableID)
        
        let bounds = collectionView.bounds
        let sizeA = (bounds.size.width - 25) / 7
        cellSize = CGSize(width: sizeA , height: sizeA)
        
        collectionView.layoutSubviews()
        
        let number = mainCalendar.components(.month, from: ePast, to: eFuture, options: .matchLast).month!
        
        //delete for release
        if debugMode {
            print("[DEBUG] CalendarView.numberOfSections(in collectionView: UICollectionView) -> Int {let number} : \(number)")
        }
        
        return number
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layoutT = UICollectionViewLayout()
        super.init(frame: frame, collectionViewLayout: layoutT)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Asks your data source object for the number of items in the specified section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        collectionView.backgroundColor = UIColor.clear
        let number = DAYS_IN_WEEK*Int(MAX_WEEKS_IN_MONTH)
        
        return number
    }
    
    
    // Asks your data source object for the cell that corresponds to the specified item in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableID, for: indexPath) as! CalendarViewCell

        visibleMonth = indexPath.section
        rangeOfDaysInMonth = mainCalendar.range(of: .day, in: .month, for: firstDayOfMonth).length

        let isToday = isTodayCheck(indexPathItem: (indexPath.item + 1), section: indexPath.section)
        
        
        if isToday {
                
                cell.label.textColor = CALENDARORANGE
                
            } else {
                
                if darkMode{
                    
                    cell.label.textColor = CALENDARWHITE
                    
                } else {
                    
                    cell.label.textColor = CALENDARGREY
                    
                }
            }
        if ((indexPath.item + 1) < firstWeekDayOfMonth) || ((indexPath.item + 2) > (rangeOfDaysInMonth + firstWeekDayOfMonth)){
            
            cell.isHidden = true
            cell.label.text = "NIM"
            
        } else {
            
            cell.isHidden = false
            cell.label.text = String(indexPath.item - firstWeekDayOfMonth + 2)
            
        }
            if selectedCellIndexPath == indexPath {
                if isToday{
                    cell.isSelected = true
                    self.visualSelectCell(cell, isToday: true)
                    selectedCellIndexPath = indexPath
                    if debugMode {
                        print("[DEBUG] Loaded SelectedTodaysCell for MonthView")
                    }
                } else {
                    cell.isSelected = true
                    self.visualSelectCell(cell, isToday: false)
                    selectedCellIndexPath = IndexPath(item: indexPath.item, section: indexPath.section)
                    if debugMode {
                        print("[DEBUG] Loaded SelectedNormalCell for MonthView")
                    }
                }
        }
        return cell
    }
    
    
    //Tells the delegate that the item at the specified index path was selected.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath == selectedCellIndexPath {
            return
        }
        
        visualDeselectCell(collectionView)
        
        
        //Locale const Variable if cell is assigned to TodaysDate
        let isToday = isTodayCheck(indexPathItem: indexPath.item + 1, section: indexPath.section)

        //Create cell to access its components
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarViewCell else {
            if failureMode {
                print("[FAILURE] SELECTING CELL WHICH DOES NOT EXIST!")
            }
            return
        }
        
        visualSelectCell(cell, isToday: isToday)
        
        guard let dayNum = cell.label.text else {
            if failureMode {
                print("[FAILURE] NO CELL LABEL TEXT!")
            }
            return
        }
        
        selectedDay = mainCalendar.date(era: mainCalendar.component(.era, from: ePast), year: mainCalendar.component(.year, from: ePast), month: mainCalendar.component(.month, from: ePast) + indexPath.section, day: mainCalendar.component(.day, from: ePast) + indexPath.item - firstWeekDayOfMonth + 1, hour: mainCalendar.component(.hour, from: ePast), minute: mainCalendar.component(.minute, from: ePast), second: mainCalendar.component(.second, from: ePast), nanosecond: mainCalendar.component(.nanosecond, from: ePast))!
        
        selectedCellIndexPath = indexPath
        
        selectedCellDayString = dayNum
        
        selectedCellMonthInt = indexPath.section % 12
        
        isSelectedDayToday = isToday
        
        selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_right")
        eventTableView.reloadView()
    }
    
    
    //Tells the delegate that the item at the specified path was deselected.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        visualDeselectCell(collectionView)
        
    }
    
    
    //MARK: DelegateFunctions
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return cellSize!
        
    }
}


extension CalendarView{
    
    func visualSelectCell(_ cell: CalendarViewCell, isToday: Bool) {
        
        let content = cell.contentView
        let label = cell.label
        
        if isToday {
            
            if darkMode{
                
                label.textColor = CALENDARWHITE
                
            } else {
                
                label.textColor = CALENDARGREY
                
            }
            
        } else {
            
            if darkMode  {
                
                label.textColor = CALENDARGREY
                
            } else {
                
                label.textColor = CALENDARWHITE
                
            }
            
        }
        
        content.backgroundColor = CALENDARORANGE
        
    }
    
    func visualDeselectCell(_ collectionView: UICollectionView){
        
        if debugMode {
            print("[DEBUG] SelectedCellIndexPath: \(selectedCellIndexPath)")
        }
        
        //Locale const Variable if cell is assigned to TodaysDate
        let isToday = isTodayCheck(indexPathItem: selectedCellIndexPath.item + 1, section: selectedCellIndexPath.section)
        
        //Create cell to access its components
        guard let cell = collectionView.cellForItem(at: IndexPath(item: selectedCellIndexPath.item, section: selectedCellIndexPath.section)) as? CalendarViewCell else {
            if failureMode {
                print("[FAILURE] FOUND NO CELL TO VISUALLY DESELECT!")
            }
            return
        }
        
        let content = cell.contentView
        let label = cell.label
        
        //Check if application is in darkmode state
        //Then change the backgroundColor of the cells to the color of the superview
        //and change the textColor
        if darkMode {
            
            //Check if isToday true, more information at isToday declaration
            if isToday{
                
                label.textColor = CALENDARORANGE
                
            } else {
                
                label.textColor = CALENDARWHITE
                
            }
            
        } else {
            
            //Check if isToday true, more information at isToday declaration
            if isToday{
                
                label.textColor = CALENDARORANGE
                
            } else {
                
                label.textColor = CALENDARGREY
                
            }
        }
        
        content.backgroundColor = UIColor.clear
    }
    
    func updateMonth(monthIndex: Int){
        
        //delete for release
        if debugMode {
            print("[DEBUG] CalendarView.updateMonth(monthIndex: Int, headerAccess: Bool) {var monthIndex} : \(monthIndex)")
        }
        
        firstDayOfMonth = mainCalendar.date(era: mainCalendar.component(.era , from: ePast), year: mainCalendar.component(.year , from: ePast), month: mainCalendar.component(.month , from: ePast) + monthIndex, day: 1, hour: mainCalendar.component(.hour , from: firstDayOfMonth), minute: mainCalendar.component(.minute , from: firstDayOfMonth), second: mainCalendar.component(.second , from: firstDayOfMonth), nanosecond: mainCalendar.component(.nanosecond , from: firstDayOfMonth))!
        
        rangeOfDaysInMonth = mainCalendar.range(of: .day, in: .month, for: firstDayOfMonth).length
        
        times = times + 1
        
        firstWeekDayOfMonth = mainCalendar.component(.weekday, from: firstDayOfMonth)
        
        //delete for release
        if informationMode {
            print("[INFORMATION] Updated Month !!!: times: \(times) \n")
            print("[INFORMATION] firstDayOfMonth: \(firstDayOfMonth)")
            print("!!![INFORMATION]!!! FIRSTWEEKDAYOFMONTH: \(firstWeekDayOfMonth)")
            print("!!![INFORMATION]!!! rnage: \(String(describing: rangeOfDaysInMonth))")
        }
    }
    
    func updateMonthbyCurrentMonth(nextMonth: Int) {
        
        //delete for release
        if debugMode {
            print("[DEBUG] CalendarView.updateMonth(monthIndex: Int, headerAccess: Bool) {var monthIndex} : \(nextMonth)")
        }
        
        firstDayOfMonth = mainCalendar.date(era: mainCalendar.component(.era , from: firstDayOfMonth), year: mainCalendar.component(.year , from: firstDayOfMonth), month: mainCalendar.component(.month , from: firstDayOfMonth) + nextMonth, day: 1, hour: mainCalendar.component(.hour , from: firstDayOfMonth), minute: mainCalendar.component(.minute , from: firstDayOfMonth), second: mainCalendar.component(.second , from: firstDayOfMonth), nanosecond: mainCalendar.component(.nanosecond , from: firstDayOfMonth))!
        
        rangeOfDaysInMonth = mainCalendar.range(of: .day, in: .month, for: firstDayOfMonth).length
        
        times = times + 1
        
        firstWeekDayOfMonth = mainCalendar.component(.weekday, from: firstDayOfMonth)
        
        //delete for release
        if informationMode {
            print("[INFORMATION] Updated Month !!!: times: \(times) \n")
            print("[INFORMATION] firstDayOfMonth: \(firstDayOfMonth)")
            print("!!![INFORMATION]!!! FIRSTWEEKDAYOFMONTH: \(firstWeekDayOfMonth)")
            print("!!![INFORMATION]!!! rnage: \(String(describing: rangeOfDaysInMonth))")
        }
    }
    
    
    func isTodayCheck(indexPathItem: Int, section: Int) -> Bool {
        
        let todaysDateNumInMonth = mainCalendar.component(.day, from: todaysDate) + firstWeekDayOfMonth
        
        let monthSinceFirst = (mainCalendar.components(.month, from: ePast, to: todaysDate, options: .matchLast).month)!
        
        if ((indexPathItem + 1) == todaysDateNumInMonth) && (section == monthSinceFirst) {
            
            return true
            
        } else {
            
            return false
            
        }
    }
    
    func getMonthName(monthDate: Date) -> String {
        let prestr = monthName[mainCalendar.component(.month, from: monthDate) - 1]
        let poststr = String(mainCalendar.component(.year, from: firstDayOfMonth))
        let str = "\(prestr) \(poststr)"
        return str
    }
    
    func scrollToNextSection(_ collectionView: CalendarView, monthIndex: Int, animated: Bool){
        collectionView.allowsSelection = false
        collectionView.scrollToItem(at: IndexPath(item: 0, section: monthIndex), at: .top, animated: animated)
        collectionView.allowsSelection = true
    }
}
