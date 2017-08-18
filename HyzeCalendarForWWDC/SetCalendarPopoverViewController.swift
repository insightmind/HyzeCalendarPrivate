//
//  SetCalendarPopoverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/18/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SetCalendarPopoverViewController: UIViewController {
	
	@IBOutlet weak var popover: UIView!
	
	var eventInformations = EManagement.eventInformation
	
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func save(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        self.popover.layer.cornerRadius = 20
		self.popover.layer.masksToBounds = true
		eventInformations.setCalendarPopoverViewController = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
