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
    
    //MARK: Functions
    
    //MARK: DataSourceFunctions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.register(CalendarViewDayCollectionViewCell.self, forCellWithReuseIdentifier: cellReusableID)
        
        let bounds = collectionView.bounds
        let sizeA = (bounds.size.width - 25) / 7
        cellSize = CGSize(width: sizeA , height: sizeA)
        
        collectionView.layoutSubviews()
        
        let number = TMCalendar.components(.month, from: TMPast, to: TMFuture, options: .matchLast).month!
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableID, for: indexPath) as! CalendarViewDayCollectionViewCell

		let isToday = TMCalendar.isDateInToday(TimeManagement.convertToDate(indexPath))
        
        if isToday {
                
                cell.label.textColor = CALENDARORANGE
                
            } else {
                
                if darkMode{
                    
                    cell.label.textColor = CALENDARWHITE
                    
                } else {
                    
                    cell.label.textColor = CALENDARGREY
                    
                }
            }
            if HSelection.selectedTime.conformToIndexPath() == indexPath {
                if isToday{
                    cell.isSelected = true
                    self.visualSelectCell(cell, isToday: true)
                    HSelection.selectedTime = TMTime.init(indexPath)
                    if debugMode {
                        print("[DEBUG] Loaded SelectedTodaysCell for MonthView")
                    }
                } else {
                    cell.isSelected = true
                    self.visualSelectCell(cell, isToday: false)
                    HSelection.selectedTime = TMTime.init(indexPath)
                    if debugMode {
                        print("[DEBUG] Loaded SelectedNormalCell for MonthView")
                    }
                }
        }
        return cell
    }
    
    
    //Tells the delegate that the item at the specified index path was selected.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath == HSelection.selectedTime.conformToIndexPath() {
            return
        }
        
        visualDeselectCell(collectionView)
        
        
        //Locale const Variable if cell is assigned to TodaysDate
        let isToday = TMCalendar.isDateInToday(TimeManagement.convertToDate(indexPath, itemOffset: 1, sectionOffset: 1))

        //Create cell to access its components
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarViewDayCollectionViewCell else {
            if failureMode {
                print("[FAILURE] SELECTING CELL WHICH DOES NOT EXIST!")
            }
            return
        }
        
        visualSelectCell(cell, isToday: isToday)
        
        HSelection.selectedTime = TMTime.init(indexPath)
        
        selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_right")
        eventTableView.reloadView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let ccell = cell as? CalendarViewDayCollectionViewCell else {
            print("[FAILURE] Displayed Cell does not conform to the requirements of the custom CVCell")
            return
        }
		
		let timeConform = TMTime(IndexPath(item: indexPath.item, section: indexPath.section + 1))
        
        if timeConform.dayOffID < 1 || timeConform.dayOffID > timeConform.monthRange {
            ccell.isHidden = true
            ccell.label.text = "NIM"
            
        } else {
            
            ccell.isHidden = false
            ccell.label.text = String(timeConform.dayOffID)
            
        }
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
    
    func visualSelectCell(_ cell: CalendarViewDayCollectionViewCell, isToday: Bool) {
        
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
            print("[DEBUG] SelectedCellIndexPath: \(HSelection.selectedTime.conformToIndexPath())")
        }
		
		let indexPath = HSelection.selectedTime.conformToIndexPath()
        
        //Locale const Variable if cell is assigned to TodaysDate
		let isToday = TMCalendar.isDateInToday(TimeManagement.convertToDate(indexPath, itemOffset: 1, sectionOffset: 1))
        
        //Create cell to access its components
        guard let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.item, section: indexPath.section)) as? CalendarViewDayCollectionViewCell else {
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
    
    func scrollToNextSection(_ collectionView: CalendarView, monthIndex: Int, animated: Bool){
        
        collectionView.allowsSelection = false
        collectionView.scrollToItem(at: IndexPath(item: 0, section: monthIndex), at: .top, animated: animated)
        collectionView.allowsSelection = true
    }
    
    func updateUntilComplet(completion: (_ success: Bool) -> Void, offset: Int, collectionView: CalendarView) {
        HSelection.currentSection += offset
        completion(true)
    }
    
}
