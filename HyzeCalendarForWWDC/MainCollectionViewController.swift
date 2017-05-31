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
		
		self.collectionView?.backgroundColor = UIColor.clear
		
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		let years = TMCalendar.components(.year, from: TMPast, to: TMFuture, options: .matchLast).year!
		
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
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.width - 12
		let cellSize = CGSize(width: width, height: width / 7 * 6)
		
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
		
		let tmonthID = HSelection.currentMonthID
		let tyearID = HSelection.currentYearID
		
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
		let date = TimeManagement.calculateFirstDayInMonth(yearID: HSelection.currentYearID, monthID: HSelection.currentMonthID)
		let name = TimeManagement.getMonthName(date)
		
		guard let parent = self.parent as? ViewController else {
			fatalError()
		}
		
		parent.navigationBar.title = name
	}
	
	func scrollToSection(yearID: Int, monthID: Int, animated anim: Bool = false) {
		
		let indexPath = IndexPath(item: monthID, section: yearID)
		
		HSelection.currentMonthID = monthID
		HSelection.currentYearID = yearID
		
		self.collectionView!.scrollToItem(at: indexPath, at: .centeredVertically, animated: anim)
		setMonthName()
	}
	

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
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

extension MainCollectionViewController {
	
	
	
}
