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
	@IBOutlet weak var EEshowDetail: UISwitch!
	
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
	
	@IBAction func toggleEEShowDetail(_ sender: UISwitch) {
		
		if isEEshowDetail {
			isEEshowDetail = false
		} else {
			isEEshowDetail = true
		}
		
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
				self.settingsLabel.textColor = Color.white
				self.showLines.textColor = Color.white
				self.hours24Label.textColor = Color.white
				self.darkModeLabel.textColor = Color.white
				self.animateDayViewLabel.textColor = Color.white
				self.view.backgroundColor = Color.grey
			} else {
				self.settingsLabel.textColor = Color.grey
				self.showLines.textColor = Color.grey
				self.hours24Label.textColor = Color.grey
				self.darkModeLabel.textColor = Color.grey
				self.animateDayViewLabel.textColor = Color.grey
				self.view.backgroundColor = Color.white
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
			settingsLabel.textColor = Color.white
            darkModeSwitch.isOn = true
            showLines.textColor = Color.white
            hours24Label.textColor = Color.white
            darkModeLabel.textColor = Color.white
			self.animateDayViewLabel.textColor = Color.white
			view.backgroundColor = Color.grey
        } else {
			settingsLabel.textColor = Color.grey
            darkModeSwitch.isOn = false
            showLines.textColor = Color.grey
            hours24Label.textColor = Color.grey
            darkModeLabel.textColor = Color.grey
			self.animateDayViewLabel.textColor = Color.grey
            view.backgroundColor = Color.white
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
		if isEEshowDetail {
			EEshowDetail.isOn = true
		} else {
			EEshowDetail.isOn = false
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
