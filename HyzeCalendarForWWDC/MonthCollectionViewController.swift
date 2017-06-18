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
    internal let prevDaysInMonth: Int
    internal let futDaysInMonth: Int
	
	let _weeksInMonth = 6
	let _daysInWeek = 7
    
    var isLastRowNecessary: Bool = true
	
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
		self.daysInMonth = TimeManagement.calculateDaysInMonth(yearID: yearID, monthID: monthID + 1)
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
        self.prevDaysInMonth = TimeManagement.calculateDaysInMonth(yearID: prevYearID, monthID: prevMonthID )
        self.futDaysInMonth = TimeManagement.calculateDaysInMonth(yearID: futYearID, monthID: futMonthID)
		let fdim = TimeManagement.calculateFirstWeekDayOfMonth(yearID: yearID, monthID: monthID)
        if fdim == 6 {
            self.firstDayInMonth = -1
        } else {
            self.firstDayInMonth = fdim
        }
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
        
		let item = calculateConformedItem(indexPath)
        var isNotInMonth: Bool
        
		if item < 1 {
            isNotInMonth = true
            cell.label?.text = String(prevDaysInMonth + item)
            cell.isSelectable = false
        } else if item > daysInMonth {
            if indexPath.item == 35 || !isLastRowNecessary {
                cell.isHidden = true
                isLastRowNecessary = false
                return cell
            }
            isNotInMonth = true
            cell.label?.text = String(item - daysInMonth)
            cell.isSelectable = false
        } else {
            if showLinesInCalendarView {
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
        let superViewController = UIApplication.shared.keyWindow?.rootViewController
        var mainViewController: ViewController
        var longMonthConstraint: NSLayoutConstraint?
        var shortMonthConstraint: NSLayoutConstraint?
        for i in (superViewController?.childViewControllers)! {
            if i.title == "MonthView" {
                mainViewController = i as! ViewController
                for l in mainViewController.calendarView.constraints {
                    if l.identifier == "longMonth" {
                        longMonthConstraint = l
                    } else if l.identifier == "shortMonth" {
                        shortMonthConstraint = l
                    }
                }
            }
        }
        if isLastRowNecessary {
            longMonthConstraint?.isActive = true
            shortMonthConstraint?.isActive = false
        } else {
            longMonthConstraint?.isActive = false
            shortMonthConstraint?.isActive = true
        }
		
		let isToday = TimeManagement.isToday(yearID: yearID, monthID: monthID, dayID: item)
		let isSelected = TimeManagement.isSelected(yearID: yearID, monthID: monthID, dayID: item)
		cell.setCellDesign(isToday: isToday, isSelected: isSelected, isNotInMonth: isNotInMonth)
        
        if isSelected {
            HSelection.selectedDayCellIndex = (yearID, monthID, IndexPath(item: item, section: 0))
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
		return indexPath.item - firstDayInMonth
	}
	
}

extension MonthCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else {
            print("Could not select Cell")
            return
        }
        if !cell.isSelectable {
            return
        }
        
        let (yID, mID, prevIndexPath) = HSelection.selectedDayCellIndex
        
        if yID == yearID && mID == monthID {
            guard let checkedPrevIndexPath = prevIndexPath else {
                fatalError()
            }
            self.collectionView(collectionView, didDeselectItemAt: checkedPrevIndexPath)
        }
        
        let item = calculateConformedItem(indexPath)
        if prevIndexPath?.item == item {
            return
        }
        let isSelected = true
        let isToday = TimeManagement.isToday(yearID: yearID, monthID: monthID, dayID: item)
        let configuredIndexPath = IndexPath(item: indexPath.item - firstDayInMonth, section: 0)
        HSelection.selectedDayCellIndex = (yearID, monthID, configuredIndexPath)
        let prevSize = cell.contentView.bounds
        cell.contentView.bounds = CGRect.zero
        cell.contentView.layer.cornerRadius = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.setCellDesign(isToday: isToday, isSelected: isSelected)
            cell.contentView.layer.cornerRadius = prevSize.width / 2
            cell.contentView.bounds = prevSize
        }, completion: nil)
    
        
        let superViewController = UIApplication.shared.keyWindow?.rootViewController
        var mainViewController: ViewController
        for i in (superViewController?.childViewControllers)! {
            if i.title == "MonthView" {
                mainViewController = i as! ViewController
                mainViewController.reloadEventTableView()
                mainViewController.updateSelectedDayIcon()
            }
        }
        
        cell.isSelected = true
        
        if informationMode {
        print("\(indexPath): | \(TimeManagement.convertToDate(yearID: yearID, monthID: monthID, dayID: indexPath.item))")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else {
            print("Could not deselect Cell")
            return
        }
        if !cell.isSelectable {
            return
        }
        
        let item = calculateConformedItem(indexPath)
        
        let isSelected = false
        let isToday = TimeManagement.isToday(yearID: yearID, monthID: monthID, dayID: item)
        
        cell.setCellDesign(isToday: isToday, isSelected: isSelected)
    }
}
