//
//  PopoverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 23.11.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    let eventInformations = EventManagement.shared.eventInformation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventInformations.eventEditor?.setButtons(shouldHide: true)
        // Do any additional setup after loading the view.
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        eventInformations.eventEditor?.setButtons(shouldHide: false)
        super.dismiss(animated: flag, completion: completion)
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
