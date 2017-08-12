//
//  SettingsViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var hours24Label: UILabel!
    @IBOutlet weak var hours24Switch: UISwitch!
    @IBOutlet weak var showLinesSwitch: UISwitch!
    @IBOutlet weak var showLines: UILabel!
	@IBOutlet weak var settingsLabel: UILabel!
	@IBOutlet weak var animateDayViewLabel: UILabel!
	@IBOutlet weak var animateDayViewSwitch: UISwitch!
	@IBOutlet weak var startWeekDaySegmentedControl: UISegmentedControl!
	
	@IBAction func toggleAnimateDayView(_ sender: UISwitch) {
		let defaults = UserDefaults.standard
		if animateDayView {
			animateDayView = false
		} else {
			animateDayView = true
		}
		defaults.set(animateDayView, forKey: "animateDayView")
		defaults.synchronize()
	}
	
    @IBAction func toggleShowLinesInCalendarView(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if showLinesInCalendarView {
            showLinesInCalendarView = false
        } else {
            showLinesInCalendarView = true
        }
        needsDesignUpdate = true
        defaults.set(showLinesInCalendarView, forKey: "showLinesInCalendarView")
        defaults.synchronize()
    }

    @IBAction func toggleDarkMode(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if darkMode{
            darkMode = false
        } else {
            darkMode = true
        }
        needsDesignUpdate = true
        defaults.set(darkMode, forKey: "DarkMode")
        defaults.synchronize()
		UIView.animate(withDuration: 0.4) {
			if darkMode{
				self.settingsLabel.textColor = Theme.calendarWhite
				self.showLines.textColor = Theme.calendarWhite
				self.hours24Label.textColor = Theme.calendarWhite
				self.darkModeLabel.textColor = Theme.calendarWhite
				self.animateDayViewLabel.textColor = Theme.calendarWhite
				self.view.backgroundColor = Theme.calendarGrey
			} else {
				self.settingsLabel.textColor = Theme.calendarGrey
				self.showLines.textColor = Theme.calendarGrey
				self.hours24Label.textColor = Theme.calendarGrey
				self.darkModeLabel.textColor = Theme.calendarGrey
				self.animateDayViewLabel.textColor = Theme.calendarGrey
				self.view.backgroundColor = Theme.calendarWhite
			}
		}
    }
	
	@IBAction func toggleWeekDayStart(_ sender: UISegmentedControl) {
		HSelection.weekDayStart = WeekDay(rawValue: sender.selectedSegmentIndex)!
		let defaults = UserDefaults.standard
		defaults.set(HSelection.weekDayStart.rawValue, forKey: "firstWeekDayOfWeek")
		defaults.synchronize()
		needsDesignUpdate = true
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
        if darkMode {
			settingsLabel.textColor = Theme.calendarWhite
            darkModeSwitch.isOn = true
            showLines.textColor = Theme.calendarWhite
            hours24Label.textColor = Theme.calendarWhite
            darkModeLabel.textColor = Theme.calendarWhite
			self.animateDayViewLabel.textColor = Theme.calendarWhite
			view.backgroundColor = Theme.calendarGrey
        } else {
			settingsLabel.textColor = Theme.calendarGrey
            darkModeSwitch.isOn = false
            showLines.textColor = Theme.calendarGrey
            hours24Label.textColor = Theme.calendarGrey
            darkModeLabel.textColor = Theme.calendarGrey
			self.animateDayViewLabel.textColor = Theme.calendarGrey
            view.backgroundColor = Theme.calendarWhite
        }
        if isAMPM {
            hours24Switch.isOn = false
        } else {
            hours24Switch.isOn = true
        }
        if showLinesInCalendarView {
            showLinesSwitch.isOn = true
        } else {
            showLinesSwitch.isOn = false
        }
		startWeekDaySegmentedControl.selectedSegmentIndex = HSelection.weekDayStart.rawValue
		if animateDayView {
			animateDayViewSwitch.isOn = true
		} else {
			animateDayViewSwitch.isOn = false
		}
    }

    @IBAction func toggle24Hour(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if isAMPM {
            isAMPM = false
        } else {
            isAMPM = true
        }
        defaults.set(isAMPM, forKey: "IsAMPM")
        defaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
