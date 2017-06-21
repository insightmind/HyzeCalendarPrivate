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
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var navigationBar: UINavigationBar!
	
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
				self.navigationBar.barTintColor = calendarGrey
				self.navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = calendarWhite
				self.saveButton.tintColor = calendarWhite
				self.isMondayLabel.textColor = calendarWhite
				self.showLines.textColor = calendarWhite
				self.hours24Label.textColor = calendarWhite
				self.darkModeLabel.textColor = calendarWhite
				self.view.backgroundColor = calendarGrey
			} else {
				self.navigationBar.barTintColor = calendarWhite
				self.navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = calendarGrey
				self.saveButton.tintColor = calendarGrey
				self.isMondayLabel.textColor = calendarGrey
				self.showLines.textColor = calendarGrey
				self.hours24Label.textColor = calendarGrey
				self.darkModeLabel.textColor = calendarGrey
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
			navigationBar.barTintColor = calendarGrey
			navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = calendarWhite
			saveButton.tintColor = calendarWhite
            darkModeSwitch.isOn = true
			isMondayLabel.textColor = calendarWhite
            showLines.textColor = calendarWhite
            hours24Label.textColor = calendarWhite
            darkModeLabel.textColor = calendarWhite
			view.backgroundColor = calendarGrey
        } else {
			navigationBar.barTintColor = calendarWhite
			navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = calendarGrey
			saveButton.tintColor = calendarGrey
			isMondayLabel.textColor = calendarGrey
            darkModeSwitch.isOn = false
            showLines.textColor = calendarGrey
            hours24Label.textColor = calendarGrey
            darkModeLabel.textColor = calendarGrey
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
