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
        Settings.shared.needsDesignUpdate = .all
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        return
    }

}
