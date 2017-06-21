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
        
        if darkMode{
            showLines.textColor = CALENDARWHITE
            hours24Label.textColor = CALENDARWHITE
            darkModeLabel.textColor = CALENDARWHITE
            view.backgroundColor = CALENDARGREY
        } else {
            showLines.textColor = CALENDARWHITE
            hours24Label.textColor = CALENDARGREY
            darkModeLabel.textColor = CALENDARGREY
            view.backgroundColor = CALENDARWHITE
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
            darkModeSwitch.isOn = true
            showLines.textColor = CALENDARWHITE
            hours24Label.textColor = CALENDARWHITE
            darkModeLabel.textColor = CALENDARWHITE
            view.backgroundColor = CALENDARGREY
        } else {
            darkModeSwitch.isOn = false
            showLines.textColor = CALENDARGREY
            hours24Label.textColor = CALENDARGREY
            darkModeLabel.textColor = CALENDARGREY
            view.backgroundColor = CALENDARWHITE
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
