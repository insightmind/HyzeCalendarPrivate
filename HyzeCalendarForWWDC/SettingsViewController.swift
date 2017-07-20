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
	@IBOutlet weak var isMondaySwitch: UISwitch!
	@IBOutlet weak var isMondayLabel: UILabel!
	@IBOutlet weak var settingsLabel: UILabel!
	@IBOutlet weak var animateDayViewLabel: UILabel!
	@IBOutlet weak var animateDayViewSwitch: UISwitch!
	
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
				self.settingsLabel.textColor = calendarWhite
				self.isMondayLabel.textColor = calendarWhite
				self.showLines.textColor = calendarWhite
				self.hours24Label.textColor = calendarWhite
				self.darkModeLabel.textColor = calendarWhite
				self.animateDayViewLabel.textColor = calendarWhite
				self.view.backgroundColor = calendarGrey
			} else {
				self.settingsLabel.textColor = calendarGrey
				self.isMondayLabel.textColor = calendarGrey
				self.showLines.textColor = calendarGrey
				self.hours24Label.textColor = calendarGrey
				self.darkModeLabel.textColor = calendarGrey
				self.animateDayViewLabel.textColor = calendarGrey
				self.view.backgroundColor = calendarWhite
			}
		}
    }
    
	@IBAction func toggleIsMondayFirstWeekDay(_ sender: UISwitch) {
		let defaults = UserDefaults.standard
		if isMondayFirstWeekday {
			isMondayFirstWeekday = false
		} else {
			isMondayFirstWeekday = true
		}
		needsDesignUpdate = true
		defaults.set(isMondayFirstWeekday, forKey: "isMondayFirstWeekday")
	}
	
	override func viewWillAppear(_ animated: Bool) {
        if darkMode {
			settingsLabel.textColor = calendarWhite
            darkModeSwitch.isOn = true
			isMondayLabel.textColor = calendarWhite
            showLines.textColor = calendarWhite
            hours24Label.textColor = calendarWhite
            darkModeLabel.textColor = calendarWhite
			self.animateDayViewLabel.textColor = calendarWhite
			view.backgroundColor = calendarGrey
        } else {
			settingsLabel.textColor = calendarGrey
			isMondayLabel.textColor = calendarGrey
            darkModeSwitch.isOn = false
            showLines.textColor = calendarGrey
            hours24Label.textColor = calendarGrey
            darkModeLabel.textColor = calendarGrey
			self.animateDayViewLabel.textColor = calendarGrey
            view.backgroundColor = calendarWhite
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
		if isMondayFirstWeekday {
			isMondaySwitch.isOn = true
		} else {
			isMondaySwitch.isOn = false
		}
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
