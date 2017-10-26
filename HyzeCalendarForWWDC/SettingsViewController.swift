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
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
        
        topBarBlurView.effect = blurEffect
        backgroundBlurView.effect = blurEffect
        
        titleTextField.textColor = Settings.shared.isDarkMode ? Color.white : Color.black
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
