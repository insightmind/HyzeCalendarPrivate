//
//  SettingsViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 24.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var topBarBlurView: UIVisualEffectView!
    @IBOutlet weak var back: UIButton!
    
    
    @IBAction func back(_ sender: UIButton) {
        Settings.shared.needsDesignUpdate = true
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Settings.shared.isDarkMode ? Color.black : Color.white
        
        topBarBlurView.effect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
        
        titleTextField.textColor = Settings.shared.isDarkMode ? Color.white : Color.black
        back.tintColor = Color.blue
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if Settings.shared.isDarkMode{
            Settings.shared.isDarkMode = false
        } else {
            Settings.shared.isDarkMode = true
        }
        Settings.shared.needsDesignUpdate = true
        defaults.set(Settings.shared.isDarkMode, forKey: "DarkMode")
        defaults.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        return
    }

}
