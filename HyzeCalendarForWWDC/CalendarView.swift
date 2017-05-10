//
//  CalendarViewDataSource.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

//TODO: Convert to Controller

import UIKit
import Foundation

class CalendarView:UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
	
    @IBOutlet weak var eventTableView: EventTableView!
    
    @IBOutlet weak var selectedDayButton: UIBarButtonItem!
    
    //MARK: Properties
    //mostly used for UICollectionViewDataSource functions
    
    //ReusableID Declaration for the cells in collectionview representing a day
    let cellReusableID = "yearcell"
    
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
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layoutT = UICollectionViewLayout()
        super.init(frame: frame, collectionViewLayout: layoutT)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Asks your data source object for the number of items in the specified section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		collectionView.register(CalendarViewYearCollectionViewCell.self, forCellWithReuseIdentifier: cellReusableID)
		collectionView.dataSource = self
		collectionView.allowsSelection = false
		
		let sizeA = collectionView.bounds.size.width - 25
		cellSize = CGSize(width: sizeA , height: sizeA * 12)

        let number = TMCalendar.components(.year, from: TMPast, to: TMFuture, options: .matchLast).year!
        
        return number
    }
    
	
    // Asks your data source object for the cell that corresponds to the specified item in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableID, for: indexPath) as! CalendarViewYearCollectionViewCell
		
		
		
		cell.initialize()
		
		return cell
    }
    
    
    //MARK: DelegateFunctions
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return cellSize!
        
    }
}


extension CalendarView{
    
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
