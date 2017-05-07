//
//  dayViewUIVViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class dayViewUIVViewController: UIViewController {

    @IBOutlet weak var day: dayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setdarkMode()
        viewIsDayView = true
        renDayView = day
        day.setUp()


        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewIsDayView = true
        renDayView = nil
    }
    
    func setdarkMode(){
        if darkMode {
            view.backgroundColor = CALENDARGREY
        } else {
            view.backgroundColor = CALENDARWHITE
        }
        day.dayViewCenterButton.backgroundColor = CALENDARORANGE
    }
    
    @IBAction func unwindToRed(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            
        
    }
     */
}
