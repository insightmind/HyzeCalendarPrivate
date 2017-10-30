//
//  DayViewUIViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DayViewUIVViewController: UIViewController {
	
	enum direction {
		case left
		case right
	}

    @IBOutlet weak var day: DayView!
	
	@IBOutlet weak var dayViewNormal: NSLayoutConstraint!
	@IBOutlet weak var dayViewRight: NSLayoutConstraint!
	@IBOutlet weak var dayViewLeft: NSLayoutConstraint!
    
    @IBOutlet weak var eventListTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dayTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dayWidthConstraint: NSLayoutConstraint!
    
    var eventList: ETViewController?
    
    lazy var topChange: UIViewPropertyAnimator = {
        let cubicParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let springParameters = UISpringTimingParameters(dampingRatio: 0.6)
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
        animator.isInterruptible = true
        return animator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        Settings.shared.viewIsDayView = true
        Settings.shared.renDayView = day
        day.setUp()
        setEventListHeight()
        

		
        // Do any additional setup after loading the view.
    }
    
    func setEventListHeight() {
        guard let maxHeight = self.navigationController?.visibleViewController?.view.frame.height else { return }
        let state = Design.shared.currentETViewState
        switch state {
        case .normal:
            eventListTopConstraint.constant = 2*dayTopConstraint.constant + day.frame.height
        case .minimal:
            eventListTopConstraint.constant = maxHeight - 100
        case .expanded:
            eventListTopConstraint.constant = 0
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Settings.shared.viewIsDayView = true
        Settings.shared.renDayView = nil
    }
    
	func setDesign(animated: Bool = false) {
        if Settings.shared.isDarkMode {
            view.backgroundColor = Color.black
			navigationController?.navigationBar.tintColor = Color.white
        } else {
            view.backgroundColor = Color.white
			navigationController?.navigationBar.tintColor = Color.black
        }
		
		UIView.animate(withDuration: animated ? 0.7 : 0, animations: {
			if Selection.shared.selectedIsToday!  {
				self.day.dayViewCenterButton.backgroundColor = Color.red
			} else if Selection.shared.selectedIsOnWeekend! {
				self.day.dayViewCenterButton.backgroundColor = Color.green
			} else {
				self.day.dayViewCenterButton.backgroundColor = Color.blue
			}
		})
		
		
    }
	//TODO: change if segues work again
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showEventEditor" {
			if let eventEditor = segue.destination as? EventEditorViewController {
				eventEditor.dayView = self
				EventManagement.shared.eventInformation = EventEditorEventInformations()
				if let key = UserDefaults.standard.string(forKey: "LocalHyzeCalendarIdentifier") {
					EventManagement.shared.eventInformation.calendar = EventManagement.shared.EMEventStore.calendar(withIdentifier: key) ?? EventManagement.shared.EMEventStore.defaultCalendarForNewEvents
				} else {
					EventManagement.shared.eventInformation.calendar = EventManagement.shared.EMEventStore.defaultCalendarForNewEvents
				}
			}
		} else if segue.identifier == "showDetail" {
			if let eventEditor = segue.destination as? EventEditorViewController {
				eventEditor.dayView = self
				EventManagement.shared.eventInformation = EventManagement.shared.selectedEventInformation
			}
        } else if segue.identifier == "embed" {
            if let eList = segue.destination as? ETViewController {
                eventList = eList
                eventList?.dayViewController = self
            }
        }
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        changeDay(.right)
    }
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        changeDay(.left)
    }
    
	func changeDay(_ direction: direction) {
		
		let (year, month, dayIndexPath) = Selection.shared.selectedDayCellIndex
		
		guard let indexPath = dayIndexPath else {
			fatalError("There is no selected day")
		}
		
		let date = TimeManagement.convertToDate(yearID: year, monthID: month, dayID: indexPath.item)
		
		var nextDate: Date
		
		switch direction {
		case .right:
			guard let tempDate = TimeManagement.calendar.date(byAdding: .day, value: -1, to: date, options: .matchLast) else {
				fatalError("Could not find previous day")
			}
			nextDate = tempDate
			
		case .left:
			guard let tempDate = TimeManagement.calendar.date(byAdding: .day, value: 1, to: date, options: .matchLast) else {
				fatalError("Could not find future day")
			}
			nextDate = tempDate
		}
		
		let newYear = TimeManagement.calendar.component(.year, from: nextDate)
		let newMonth = TimeManagement.calendar.component(.month, from: nextDate)
		let newDayIndexPath = IndexPath(item: TimeManagement.calendar.component(.day, from: nextDate), section: 0)
		
		Selection.shared.selectedDayCellIndex = (newYear, newMonth, newDayIndexPath)
		
		let weekDay = TimeManagement.calendar.component(.weekday, from: nextDate)
		
		if weekDay == 1 || weekDay == 7 {
			Selection.shared.selectedIsOnWeekend = true
		} else {
			Selection.shared.selectedIsOnWeekend = false
		}
		
		Selection.shared.selectedIsToday = TimeManagement.isToday(yearID: newYear, monthID: newMonth, dayID: newDayIndexPath.item)
		UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
			NSLayoutConstraint.deactivate([self.dayViewNormal])
			switch direction {
			case .right:
				NSLayoutConstraint.activate([self.dayViewRight])
			case .left:
				NSLayoutConstraint.activate([self.dayViewLeft])
			}
			self.view.layoutIfNeeded()
		}) { (_) in
			
			switch direction {
			case .right:
				NSLayoutConstraint.activate([self.dayViewLeft])
				NSLayoutConstraint.deactivate([self.dayViewRight])
			case .left:
				NSLayoutConstraint.deactivate([self.dayViewLeft])
				NSLayoutConstraint.activate([self.dayViewRight])
			}
            
			self.view.layoutIfNeeded()
			
			self.day.reloadData()
			self.setDesign(animated: false)
            if let eList = self.eventList {
                eList.updateDesign(true)
            }
			
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                NSLayoutConstraint.activate([self.dayViewNormal])
                switch direction {
                case .right:
                    NSLayoutConstraint.deactivate([self.dayViewLeft])
                case .left:
                    NSLayoutConstraint.deactivate([self.dayViewRight])
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
			
		}
		
		Settings.shared.needsDesignUpdate = true
	}
}
