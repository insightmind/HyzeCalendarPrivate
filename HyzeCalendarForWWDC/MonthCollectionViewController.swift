//
//  MonthCollectionViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/21/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DayCell"

class MonthCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	internal let yearID: Int
	internal let monthID: Int
	internal let daysInMonth: Int
	internal let firstDayInMonth: Int
	
	let _weeksInMonth = 6
	let _daysInWeek = 7
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.collectionView!.isScrollEnabled = false
		self.automaticallyAdjustsScrollViewInsets = true
		self.collectionView?.autoresizesSubviews = true
		self.title = "MonthCollectionViewController"
        // Do any additional setup after loading the view.
		
		self.collectionView?.allowsMultipleSelection = false
		
		collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	init(collectionViewLayout layout: UICollectionViewLayout, idOfYear yearID: Int, idOfMonth monthID: Int) {
		self.yearID = yearID
		self.monthID = monthID
		self.daysInMonth = TimeManagement.calculateDaysInMonth(yearID: yearID, monthID: monthID)
		self.firstDayInMonth = TimeManagement.calculateFirstWeekDayOfMonth(yearID: yearID, monthID: monthID)
		super.init(collectionViewLayout: layout)
		self.collectionView?.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return _daysInWeek * _weeksInMonth
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DayCollectionViewCell
		
		if indexPath.item - firstDayInMonth < 1 || indexPath.item - firstDayInMonth > daysInMonth{
			cell.isHidden = true
		} else {
			cell.label?.text = String(indexPath.item - firstDayInMonth)
		}
    
        // Configure the cell
		if HSelection.selectedYearID == yearID && HSelection.selectedMonthID == monthID - 1 && HSelection.selectedDayID == indexPath.item - firstDayInMonth {
			if darkMode {
				cell.contentView.backgroundColor = CALENDARWHITE
				cell.label?.textColor = CALENDARGREY
			} else {
				cell.contentView.backgroundColor = CALENDARGREY
				cell.label?.textColor = CALENDARWHITE
			}
			
		} else {
			if darkMode {
				cell.contentView.backgroundColor = CALENDARGREY
				cell.label?.textColor = CALENDARWHITE
			} else {
				cell.contentView.backgroundColor = CALENDARWHITE
				cell.label?.textColor = CALENDARGREY
			}
		}
    
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.bounds.width / CGFloat(_daysInWeek)
		let size = CGSize(width: width - 2, height: width - 2)
		return size
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 2
	}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
	
}

extension MonthCollectionViewController {
	
	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		guard let cell = collectionView.cellForItem(at: indexPath) else {
			print("Could not select Cell")
			return false
		}
		cell.isSelected = true
		return true
	}
	
	override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
		guard let cell = collectionView.cellForItem(at: indexPath) else {
			print("Could not deselect Cell")
			return false
		}
		cell.isSelected = false
		return true
	}
}
