//
//  CalendarViewCollectionViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/21/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MonthCell"

class MainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	@IBAction func scrollUp(_ sender: UISwipeGestureRecognizer) {
		self.scrollToSection(direction: ScrollDirection.up, animated: true)
	}
	@IBAction func scrollDown(_ sender: UISwipeGestureRecognizer) {
		self.scrollToSection(direction: ScrollDirection.down, animated: true)
	}
    
	override func viewDidLoad() {
        
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
		self.collectionView!.allowsSelection = false
		self.collectionView!.isScrollEnabled = false
        self.collectionView?.isPrefetchingEnabled = false
		self.collectionView?.layer.masksToBounds = false
		self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView!.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
    }
        
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
	
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		let years = TimeManagement.calendar.components(.year, from: TimeManagement.past, to: TimeManagement.future, options: .matchLast).year!
        return years
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 12
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MonthCollectionViewCell
		
        // Configure the cell
		if cell.controller == nil {
			let newController = MonthCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), idOfYear: indexPath.section, idOfMonth: indexPath.item)
			self.addChildViewController(newController)
			newController.view.frame = cell.bounds
			newController.view.tag = 69
			cell.addSubview(newController.view)
			newController.didMove(toParentViewController: self)
			cell.controller = newController
		}
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        switch Settings.shared.needsDesignUpdate {
        case .calendarView:
            reloadCalendarView()
        case .list:
            calculateETViewUpdate(shouldReload: true)
        case .all:
            calculateETViewUpdate(shouldReload: true)
            reloadCalendarView()
        default:
            break
        }
        Settings.shared.needsDesignUpdate = .none
    }
	
	func reloadCalendarView() {
        self.collectionView!.reloadData()
		scrollToSection(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID - 1, animated: false)
	}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 10
        let size = CGSize(width: width, height: width / 7 * 6)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
	
	func scrollToSection(direction: ScrollDirection, animated anim: Bool = false) {
		
		let tmonthID = Selection.shared.currentMonthID - 1
		let tyearID = Selection.shared.currentYearID
		
		switch direction {
		case .up:
			if tmonthID == 0 {
				if tyearID == 0 {
					break
				} else {
					self.scrollToSection(yearID: tyearID - 1, monthID: 11, animated: anim)
				}
			} else {
				self.scrollToSection(yearID: tyearID, monthID: tmonthID - 1, animated: anim)
			}
		case .down:
			if tmonthID == 11 {
				if tyearID == 3999 {
					break
				} else {
					self.scrollToSection(yearID: tyearID + 1, monthID: 0, animated: anim)
				}
			} else {
				self.scrollToSection(yearID: tyearID, monthID: tmonthID + 1, animated: anim)
			}
		}
		setMonthName()
	}
    func setMonthName(onlyYear: Bool = false) {
		let date = TimeManagement.calculateFirstDayInMonth(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID)
        let name = TimeManagement.getMonthName(date, withMonth: !onlyYear)
		
		guard let parent = self.parent as? ViewController else {
			return
		}
		
		parent.navigationBar.title = name
	}
	
    fileprivate func calculateETViewUpdate(shouldReload: Bool = false) {
		let daysInMonth = TimeManagement.calculateDaysInMonth(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID)
		
		let firstWeekDayOfMonth = TimeManagement.calculateFirstWeekDayOfMonth(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID)
		
		var conform = (firstWeekDayOfMonth - Selection.shared.weekDayStart.rawValue)
		if conform < 1 {
			conform += 7
		}
		
		if conform + daysInMonth > 36 {
            Design.shared.currentETViewIsExpandedByNumOfRows = 0
		} else if conform + daysInMonth > 29 {
            Design.shared.currentETViewIsExpandedByNumOfRows = 1
		} else {
            Design.shared.currentETViewIsExpandedByNumOfRows = 2
        }
        updateETViewHeight(self.collectionView!, shouldReload: !shouldReload)
	}
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView?.isScrollEnabled != true { return }
        guard let visibleCell = self.collectionView?.visibleCells.first else { return }
        guard let cell = visibleCell as? MonthCollectionViewCell else { return }
        guard let cellController = cell.controller else { return }
        let month = cellController.monthID
        let year = cellController.yearID
        
//        handleSelection(controller: cellController, month: month, year: year, isAppearing: false)
        
        Selection.shared.currentMonthID = month + 1
        Selection.shared.currentYearID = year
        
        setMonthName()
        
        let superViewController = UIApplication.shared.keyWindow?.rootViewController
        var mainViewController: ViewController
        for i in (superViewController?.childViewControllers)! {
            if i.title == "MonthView" {
                mainViewController = i as! ViewController
                guard let eventList = mainViewController.eventListViewController else { return }
                eventList.updateGeneralDesign()
            }
        }
    }
    
    func handleSelection(controller: MonthCollectionViewController ,month: Int, year: Int, isAppearing: Bool) {
        let (selectionYear, selectionMonth, indexPath) = Selection.shared.selectedDayCellIndex
        guard let selectedIndexPath = indexPath else { return }
        if month == selectionMonth && year == selectionYear {
            switch isAppearing {
            case true:
                controller.collectionView?.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
            case false:
                controller.collectionView?.deselectItem(at: selectedIndexPath, animated: false)
            }
        }
    }
	
	func scrollToSection(yearID: Int, monthID: Int, animated anim: Bool = false) {
		
        let indexPath = IndexPath(item: monthID, section: yearID)

        Selection.shared.currentMonthID = monthID + 1
        Selection.shared.currentYearID = yearID
		
		self.collectionView!.scrollToItem(at: indexPath, at: .top, animated: anim)
        calculateETViewUpdate(shouldReload: false)
        setMonthName()
	}
	
    func updateETViewHeight(_ collectionView: UICollectionView, shouldReload: Bool = false) {
        if Design.shared.currentETViewState != .normal {
            return
        }
		let superViewController = UIApplication.shared.keyWindow?.rootViewController
		var mainViewController: ViewController
		for i in (superViewController?.childViewControllers)! {
			if i.title == "MonthView" {
				mainViewController = i as! ViewController
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    let basicHeight = mainViewController.calendarViewToTopConstraint.constant + mainViewController.calendarView.frame.height - 10
                    let expandedValue = Design.shared.currentETViewIsExpandedByNumOfRows * ((collectionView.bounds.width / 7))
                    mainViewController.eventListHeightConstraint.constant = basicHeight - expandedValue
                    mainViewController.view.layoutIfNeeded()
                }, completion: nil)
                guard let eventList = mainViewController.eventListViewController else { return }
                eventList.updateGeneralDesign()
			}
		}
	}

}
