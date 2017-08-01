//
//  EventEditorViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 3/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class EventEditorEventInformations {
	var title: String = "Untitled Event"
	var isAllDay: Bool = false
	var startDate: Date = Date()
	var endDate: Date = Date(timeIntervalSinceNow: 1800)
	var color: UIColor = calendarWhite
}

class EventEditorViewController: UIViewController {
    
    // MARK: - Variables
    /// Variable to check if Event should be added to the Calendar
    var addEvent: Bool = false
	
	var eventInformations = EventEditorEventInformations()
	
    // MARK: - Outlets
    //All the visual Elements in the ViewController
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	
	@IBOutlet weak var tableView: UIView!
	@IBOutlet weak var newEventTextField: UITextField!
	
	// MARK: - Actions
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func save(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		if darkMode {
			newEventTextField.textColor = calendarWhite
			let color = calendarWhite.withAlphaComponent(0.5)
			let str = NSAttributedString(string: "Untitled Event", attributes: [NSForegroundColorAttributeName : color])
			newEventTextField.attributedPlaceholder = str
			blurEffectView.effect = UIBlurEffect(style: .dark)
		} else {
			blurEffectView.effect = UIBlurEffect(style: .light)
			let color = calendarGrey.withAlphaComponent(0.5)
			let str = NSAttributedString(string: "Untitled Event", attributes: [NSForegroundColorAttributeName : color])
			newEventTextField.attributedPlaceholder = str
			newEventTextField.textColor = calendarGrey
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		eventInformations.title = newEventTextField.text ?? "Untitled Event"
        guard let sd = sender as? UIButton else{
            print("sender not found")
            return
        }
        if sd.tag == 2 {
            if informationMode {
            print("added Event")
            }
            EManagement.addEvent(eventInformations)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	class func getEventsInformations() -> EventEditorEventInformations {
		if let topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				guard let viewController = presentedViewController as? EventEditorViewController else {
					fatalError()
				}
				return viewController.eventInformations
			}
		}
		return EventEditorEventInformations()
	}

}
