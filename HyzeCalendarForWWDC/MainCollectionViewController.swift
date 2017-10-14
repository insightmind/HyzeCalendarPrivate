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
        self.collectionView!.isPrefetchingEnabled = false
		self.collectionView?.layer.masksToBounds = false
		
		self.collectionView?.backgroundColor = UIColor.clear
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        self.scrollToSection(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID - 1, animated: animated)
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
			let newController = MonthCollectionViewController(collectionViewLayout: CalendarViewFlowLayout(), idOfYear: indexPath.section, idOfMonth: indexPath.item)
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
        if Settings.shared.needsDesignUpdate {
            reloadCalendarView()
            Settings.shared.needsDesignUpdate = false
        }
		self.calculateETViewUpdate()
    }
	
	func reloadCalendarView() {
		self.collectionView!.reloadData()
		scrollToSection(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID - 1, animated: false)
	}
    
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsPerRow: CGFloat = 1
		let width = UIScreen.main.bounds.width - 12
		let cellSize = CGSize(width: width / cellsPerRow, height: (width / 7 * 6) / cellsPerRow)
		
		return cellSize
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets.zero
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 5
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
	func setMonthName() {
		let date = TimeManagement.calculateFirstDayInMonth(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID)
		let name = TimeManagement.getMonthName(date)
		
		guard let parent = self.parent as? ViewController else {
			return
		}
		
		parent.navigationBar.title = name
	}
	
	fileprivate func calculateETViewUpdate() {
		
		let daysInMonth = TimeManagement.calculateDaysInMonth(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID)
		
		let firstWeekDayOfMonth = TimeManagement.calculateFirstWeekDayOfMonth(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID)
		
		var conform = (firstWeekDayOfMonth - Selection.shared.weekDayStart.rawValue)
		if conform < 1 {
			conform += 7
		}
		
		if conform + daysInMonth > 36 {
            Design.shared.currentETViewIsExpandedByNumOfRows = 0
			updateETViewHeight(self.collectionView!)
		} else if conform + daysInMonth > 29 {
            Design.shared.currentETViewIsExpandedByNumOfRows = 1
			updateETViewHeight(self.collectionView!)
		} else {
            Design.shared.currentETViewIsExpandedByNumOfRows = 2
			updateETViewHeight(self.collectionView!)
		}
	}
	
	func scrollToSection(yearID: Int, monthID: Int, animated anim: Bool = false) {
		
		let indexPath = IndexPath(item: monthID, section: yearID)
		
		Selection.shared.currentMonthID = monthID + 1
		Selection.shared.currentYearID = yearID
		
		calculateETViewUpdate()
		
		self.collectionView!.scrollToItem(at: indexPath, at: .centeredVertically, animated: anim)
		setMonthName()
	}
	
    func updateETViewHeight(_ collectionView: UICollectionView) {
        if Design.shared.currentETViewState != .normal {
            return
        }
		let superViewController = UIApplication.shared.keyWindow?.rootViewController
		var mainViewController: ViewController
		for i in (superViewController?.childViewControllers)! {
			if i.title == "MonthView" {
				mainViewController = i as! ViewController
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    let basicHeight = mainViewController.calendarViewToTopConstraint.constant + mainViewController.calendarView.frame.height
                    let expandedValue = Design.shared.currentETViewIsExpandedByNumOfRows * ((collectionView.bounds.width / 7) - 2)
                    mainViewController.eventListHeightConstraint.constant = basicHeight - expandedValue
                    mainViewController.view.layoutIfNeeded()
                }, completion: nil)
                guard let eventList = mainViewController.eventListViewController else { return }
                eventList.updateDesign()
			}
		}
	}

}
