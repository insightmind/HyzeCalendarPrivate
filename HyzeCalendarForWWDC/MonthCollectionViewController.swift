//
//  MonthCollectionViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/21/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class MonthCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	internal let yearID: Int
	internal let monthID: Int
	internal let daysInMonth: Int
	internal let firstDayInMonth: Int
    internal let prevDaysInMonth: Int
    internal let futDaysInMonth: Int
	
	private let reuseIdentifier = "DayCell"
	
	let _weeksInMonth = 6
	let _daysInWeek = 7
    
    var isLastRowNecessary: Bool = true
	var forcedCellSelection: Bool = false
	
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
		self.collectionView?.isPrefetchingEnabled = false
		
		collectionViewLayout.invalidateLayout()
    }
	
	fileprivate class func setUpPrevFutMonthDays(_ monthID: Int, _ yearID: Int) -> (prevDays: Int, futDays: Int) {
		var prevYearID: Int
		var prevMonthID: Int
		var futYearID: Int
		var futMonthID: Int
		if monthID == 0 {
			prevMonthID = 10
			prevYearID = yearID - 1
			futYearID = yearID
			futMonthID = monthID + 1
		} else {
			if monthID == 11 {
				futMonthID = 0
				futYearID = yearID + 1
			} else {
				futMonthID = monthID + 1
				futYearID = yearID
			}
			prevYearID = yearID
			prevMonthID = monthID
		}
		let prevDays = TimeManagement.calculateDaysInMonth(yearID: prevYearID, monthID: prevMonthID )
		let futDays = TimeManagement.calculateDaysInMonth(yearID: futYearID, monthID: futMonthID)
		return (prevDays, futDays)
	}
	
	init(collectionViewLayout layout: UICollectionViewLayout, idOfYear yearID: Int, idOfMonth monthID: Int) {
		self.yearID = yearID
		self.monthID = monthID
		self.daysInMonth = TimeManagement.calculateDaysInMonth(yearID: yearID, monthID: monthID + 1)
		let days = MonthCollectionViewController.setUpPrevFutMonthDays(monthID, yearID)
		self.prevDaysInMonth = days.prevDays
		self.futDaysInMonth = days.futDays
		let fdim = TimeManagement.calculateFirstWeekDayOfMonth(yearID: yearID, monthID: monthID + 1)
		self.firstDayInMonth = fdim - 1
		super.init(collectionViewLayout: layout)
		self.collectionView?.backgroundColor = UIColor.clear
		self.collectionView?.layer.masksToBounds = false
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
        
		let item = calculateConformedItem(indexPath)
        var isNotInMonth: Bool
		if item < 1{
            isNotInMonth = true
            cell.label?.text = String(prevDaysInMonth + item)
            cell.isSelectable = false
        } else if item > daysInMonth {
            isNotInMonth = true
            cell.label?.text = String(item - daysInMonth)
            cell.isSelectable = false
        } else {
            if Settings.shared.showLinesInCalendarView {
            if cell.bottomLine == nil {
                cell.bline.frame = CGRect(x: -2, y: cell.bounds.height, width: cell.bounds.width + 4, height: 1)
                cell.addSubview(cell.bline)
                cell.bottomLine = cell.bline
            }
            } else {
                if cell.bottomLine != nil {
                    cell.bottomLine?.removeFromSuperview()
                }
            }
			cell.label?.text = String(item)
            isNotInMonth = false
		}
        let isLeft = ((indexPath.item) % 7 == 0) ? true : false
        let weekNumber = isLeft ? TimeManagement.getWeekNumber(yearID: yearID, monthID: monthID + 1, dayID: item) : nil
		let isToday = TimeManagement.isToday(yearID: yearID, monthID: monthID + 1, dayID: item)
		let isSelected = TimeManagement.isSelected(yearID: yearID, monthID: monthID + 1, dayID: item)
		let isOnWeekend = self.isOnWeekend(for: indexPath)
        cell.setCellDesign(isToday: isToday, isSelected: isSelected, isNotInMonth: isNotInMonth, isOnWeekend: isOnWeekend, weekNumber: weekNumber)
        
        if isSelected {
			self.forcedCellSelection = true
            Selection.shared.selectedDayCellIndex = (yearID, monthID + 1, IndexPath(item: item, section: 0))
			Selection.shared.selectedIsOnWeekend = isOnWeekend
            self.collectionView!.selectItem(at: indexPath, animated: false, scrollPosition: .init(rawValue: 0))
            cell.isSelected = true

        } else {
            cell.isSelected = false
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
	
	func calculateConformedItem(_ indexPath: IndexPath) -> Int {
		var conform = firstDayInMonth - Selection.shared.weekDayStart.rawValue
		if conform < 0 {
			conform += 7
		}
		let item = indexPath.item - conform + 1
		return item
	}
	
}

extension MonthCollectionViewController {
    
	fileprivate func forceETViewReload() {
		let superViewController = UIApplication.shared.keyWindow?.rootViewController
		var mainViewController: ViewController
		for i in (superViewController?.childViewControllers)! {
			if i.title == "MonthView" {
				mainViewController = i as! ViewController
				//mainViewController.ETView.reloadView()
			}
		}
	}

	//TODO: [BUG] automatically deselects Cells out of Range
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else {
            print("Could not select Cell")
            return
        }
        if !cell.isSelectable {
            return
        }
        
        let (yID, mID, prevIndexPath) = Selection.shared.selectedDayCellIndex
        
        if yID == yearID && mID == monthID && !forcedCellSelection{
            guard var checkedPrevIndexPath = prevIndexPath else {
                fatalError()
            }
			checkedPrevIndexPath = IndexPath(item: checkedPrevIndexPath.item + Selection.shared.weekDayStart.rawValue, section: checkedPrevIndexPath.section)
            self.collectionView(collectionView, didDeselectItemAt: checkedPrevIndexPath)
        }
		
		let isOnWeekend = self.isOnWeekend(for: indexPath)
		let item = calculateConformedItem(indexPath)
		
        let isSelected = true
        let isToday = TimeManagement.isToday(yearID: yearID, monthID: monthID + 1, dayID: item)
        let configuredIndexPath = IndexPath(item: calculateConformedItem(indexPath) , section: 0)
		if prevIndexPath?.item == configuredIndexPath.item && yID == yearID && mID - 1 == monthID && !forcedCellSelection{
			return
		}
		Selection.shared.selectedDayCellIndex = (self.yearID, self.monthID + 1, configuredIndexPath)
		Selection.shared.selectedIsOnWeekend = self.isOnWeekend(for: indexPath)
		Selection.shared.selectedIsToday = isToday
		let prevSize = cell.contentView.bounds
		let prevShadowPath = cell.layer.shadowPath
		cell.layer.shadowPath = UIBezierPath(rect: CGRect.zero).cgPath
		cell.contentView.bounds = CGRect.zero
		cell.contentView.layer.cornerRadius = 0
		cell.contentView.backgroundColor = Settings.shared.isDarkMode ? Color.grey : Color.white
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
			
			cell.setCellDesign(isToday: isToday, isSelected: isSelected, isOnWeekend: isOnWeekend)
			cell.contentView.layer.cornerRadius = prevSize.width / 2
			cell.contentView.bounds = prevSize
			cell.layer.shadowPath = prevShadowPath
			cell.layer.shadowOpacity = 1
			
		}, completion: nil)
		forceETViewReload()
        
        cell.isSelected = true
        
        if Settings.shared.informationMode {
        print("\(indexPath): | \(TimeManagement.convertToDate(yearID: yearID, monthID: monthID, dayID: indexPath.item))")
        }
		
		forcedCellSelection = false
    }
	
	func isOnWeekend(for indexPath: IndexPath) -> Bool {
		var sundaySolution = 1 - Selection.shared.weekDayStart.rawValue
		if sundaySolution < 0 {
			sundaySolution += 7
		}
		var saturdaySolution = 0 - Selection.shared.weekDayStart.rawValue
		if saturdaySolution < 0 {
			saturdaySolution += 7
		}
		if (indexPath.item + 1) % 7 == sundaySolution || (indexPath.item + 1) % 7 == saturdaySolution {
			return true
		}
		return false
	}
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else {
            print("Could not deselect Cell")
            return
        }
        if !cell.isSelectable {
            return
        }
		
		cell.contentView.backgroundColor = UIColor.clear
        
        let item = calculateConformedItem(indexPath)
        let isOnWeekend = self.isOnWeekend(for: indexPath)
        let isSelected = false
        let isToday = TimeManagement.isToday(yearID: yearID, monthID: monthID + 1, dayID: item)
        
		cell.setCellDesign(isToday: isToday, isSelected: isSelected, isOnWeekend: isOnWeekend)
    }
}
