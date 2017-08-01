//
//  setTimePopopverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 7/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class setTimePopopverViewController: UIViewController {
	
	var eventInformations: EventEditorEventInformations!

	@IBOutlet var popover: UIView!
	@IBOutlet weak var blurLayer: UIVisualEffectView!
	
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var topLabel: UILabel!
	
	@IBAction func cancel(_ sender: UIButton) {
		switch topLabel.text! {
		case "Starts":
			eventInformations.startDate = datePicker.date
		case "Ends":
			eventInformations.endDate = datePicker.date
		default:
			return
		}
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.eventInformations = EventEditorViewController.getEventsInformations()
		switch topLabel.text! {
		case "Starts":
			datePicker.date = eventInformations.startDate
		case "Ends":
			datePicker.date = eventInformations.endDate
		default:
			datePicker.date = eventInformations.startDate
		}
		popover.layer.cornerRadius = 20
		popover.layer.masksToBounds = true

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
