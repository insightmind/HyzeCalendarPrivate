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
	@IBOutlet weak var defaultCalendarLabel: UILabel!
    @IBOutlet weak var testView: UIView!
    
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if Settings.shared.isDarkMode {
			return .lightContent
		} else {
			return .default
		}
	}
	
	@IBAction func toggleAnimateDayView(_ sender: UISwitch) {
		let defaults = UserDefaults.standard
		if Settings.shared.animateDayView {
			Settings.shared.animateDayView = false
		} else {
			Settings.shared.animateDayView = true
		}
		defaults.set(Settings.shared.animateDayView, forKey: "animateDayView")
		defaults.synchronize()
	}
	
	@IBAction func toggleShowLinesInCalendarView(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if Settings.shared.showLinesInCalendarView {
            Settings.shared.showLinesInCalendarView = false
        } else {
            Settings.shared.showLinesInCalendarView = true
        }
        Settings.shared.needsDesignUpdate = true
        defaults.set(Settings.shared.showLinesInCalendarView, forKey: "showLinesInCalendarView")
        defaults.synchronize()
    }

    @IBAction func toggleDarkMode(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if Settings.shared.isDarkMode{
            Settings.shared.isDarkMode = false
        } else {
            Settings.shared.isDarkMode = true
        }
        Settings.shared.needsDesignUpdate = true
        defaults.set(Settings.shared.isDarkMode, forKey: "DarkMode")
        defaults.synchronize()
		UIView.animate(withDuration: 0.4) {
			self.setNeedsStatusBarAppearanceUpdate()
			if Settings.shared.isDarkMode{
				self.defaultCalendarLabel.textColor = Color.white
				self.settingsLabel.textColor = Color.white
				self.showLines.textColor = Color.white
				self.hours24Label.textColor = Color.white
				self.darkModeLabel.textColor = Color.white
				self.animateDayViewLabel.textColor = Color.white
				self.view.backgroundColor = Color.grey
			} else {
				self.defaultCalendarLabel.textColor = Color.grey
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
		Selection.shared.weekDayStart = WeekDay(rawValue: sender.selectedSegmentIndex)!
		let defaults = UserDefaults.standard
		defaults.set(Selection.shared.weekDayStart.rawValue, forKey: "firstWeekDayOfWeek")
		defaults.synchronize()
		Settings.shared.needsDesignUpdate = true
	}
	
	
    func loadInformations() {
		if Settings.shared.isAMPM {
			hours24Switch.isOn = false
		} else {
			hours24Switch.isOn = true
		}
		if Settings.shared.showLinesInCalendarView {
			showLinesSwitch.isOn = true
		} else {
			showLinesSwitch.isOn = false
		}
		startWeekDaySegmentedControl.selectedSegmentIndex = Selection.shared.weekDayStart.rawValue
		if Settings.shared.animateDayView {
			animateDayViewSwitch.isOn = true
		} else {
			animateDayViewSwitch.isOn = false
		}
		self.defaultCalendarLabel.text = EventManagement.shared.EMCalendar?.title
	}
	
	override func viewWillAppear(_ animated: Bool) {
        if Settings.shared.isDarkMode {
			self.defaultCalendarLabel.textColor = Color.white
			settingsLabel.textColor = Color.white
            darkModeSwitch.isOn = true
            showLines.textColor = Color.white
            hours24Label.textColor = Color.white
            darkModeLabel.textColor = Color.white
			self.animateDayViewLabel.textColor = Color.white
			view.backgroundColor = Color.grey
        } else {
			self.defaultCalendarLabel.textColor = Color.grey
			settingsLabel.textColor = Color.grey
            darkModeSwitch.isOn = false
            showLines.textColor = Color.grey
            hours24Label.textColor = Color.grey
            darkModeLabel.textColor = Color.grey
			self.animateDayViewLabel.textColor = Color.grey
            view.backgroundColor = Color.white
        }
		loadInformations()
    }

    @IBAction func toggle24Hour(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if Settings.shared.isAMPM {
            Settings.shared.isAMPM = false
        } else {
            Settings.shared.isAMPM = true
        }
        defaults.set(Settings.shared.isAMPM, forKey: "IsAMPM")
        defaults.synchronize()
    }
	
	@IBAction func setDefaultCalendar(_ sender: UIButton) {
		
		let storyboard = UIStoryboard(name: "SelectCalendar", bundle: nil)
		
		Settings.shared.isSettingDefaultCalendar = true
		EventManagement.shared.eventInformation.calendar = EventManagement.shared.EMCalendar ?? EventManagement.shared.getHyzeCalendar()
		
		guard let viewController = storyboard.instantiateInitialViewController() else {
			return
		}
		
		self.present(viewController, animated: true, completion: nil)
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		Settings.shared.settingsView = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
