//
//  RecurrencePopoverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/27/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class RecurrencePopoverViewController: UIViewController {

	@IBOutlet weak var popover: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dailyButton: UIButton!
	@IBOutlet weak var dailyButtonView: UIView!
	@IBOutlet weak var weeklyButton: UIButton!
	@IBOutlet weak var weeklyButtonView: UIView!
	@IBOutlet weak var monthlyButton: UIButton!
	@IBOutlet weak var monthlyButtonView: UIView!
	@IBOutlet weak var yearlyButton: UIButton!
	@IBOutlet weak var yearlyButtonView: UIView!
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	@IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func save(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func selectDaily(_ sender: UIButton) {
		mainViewHeightConstraint.constant = 56
		weeklyButtonView.isHidden = true
		monthlyButtonView.isHidden = true
		yearlyButtonView.isHidden = true
		UIView.animate(withDuration: 0.5) {
			self.view.layoutIfNeeded()
		}
	}
	@IBAction func selectWeekly(_ sender: UIButton) {
	}
	@IBAction func selectMonthly(_ sender: UIButton) {
	}
	@IBAction func selectYearly(_ sender: UIButton) {
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		popover.layer.cornerRadius = 20
		popover.layer.masksToBounds = true
		
		if darkMode {
			blurEffectView.effect = UIBlurEffect(style: .dark)
			dailyButton.tintColor = Color.white
			weeklyButton.tintColor = Color.white
			monthlyButton.tintColor = Color.white
			yearlyButton.tintColor = Color.white
			popover.backgroundColor = Color.grey.withAlphaComponent(0.3)
		} else {
			blurEffectView.effect = UIBlurEffect(style: .light)
			dailyButton.tintColor = Color.grey
			weeklyButton.tintColor = Color.grey
			monthlyButton.tintColor = Color.grey
			yearlyButton.tintColor = Color.grey
			popover.backgroundColor = Color.white.withAlphaComponent(0.3)
		}
		
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
