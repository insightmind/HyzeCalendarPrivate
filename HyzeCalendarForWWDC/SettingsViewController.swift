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

    @IBAction func toggleDarkMode(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if darkMode{
            darkMode = false
        } else {
            darkMode = true
        }
        defaults.set(darkMode, forKey: "DarkMode")
        defaults.synchronize()
        
        if darkMode{
            hours24Label.textColor = CALENDARWHITE
            darkModeLabel.textColor = CALENDARWHITE
            view.backgroundColor = CALENDARGREY
        } else {
            hours24Label.textColor = CALENDARGREY
            darkModeLabel.textColor = CALENDARGREY
            view.backgroundColor = CALENDARWHITE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if darkMode {
            darkModeSwitch.isOn = true
            hours24Label.textColor = CALENDARWHITE
            darkModeLabel.textColor = CALENDARWHITE
            view.backgroundColor = CALENDARGREY
        } else {
            darkModeSwitch.isOn = false
            hours24Label.textColor = CALENDARGREY
            darkModeLabel.textColor = CALENDARGREY
            view.backgroundColor = CALENDARWHITE
        }
        if isAMPM {
            hours24Switch.isOn = false
        } else {
            hours24Switch.isOn = true
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
