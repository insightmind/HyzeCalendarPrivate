//
//  RecurrencePopoverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/27/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

enum FrequencyType {
	case none
	case daily
	case weekly
	case monthly
	case yearly
}

class RecurrencePopoverViewController: UIViewController {
	
	var eventInformations = EManagement.eventInformation
	
	var selectedFrequency: FrequencyType = .none
	
	var tableView: RecurrenceTableViewController? = nil

	@IBOutlet weak var popover: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dailyButton: UIButton!
	@IBOutlet weak var dailyButtonView: UIView!
	@IBOutlet weak var dailyCircleButton: UIButton!
	@IBOutlet weak var dailyCircleButtonView: UIView!
	@IBOutlet weak var weeklyButton: UIButton!
	@IBOutlet weak var weeklyButtonView: UIView!
	@IBOutlet weak var weeklyCircleButton: UIButton!
	@IBOutlet weak var weeklyCircleButtonView: UIView!
	@IBOutlet weak var monthlyButton: UIButton!
	@IBOutlet weak var monthlyButtonView: UIView!
	@IBOutlet weak var monthlyCircleButton: UIButton!
	@IBOutlet weak var monthlyCircleButtonView: UIView!
	@IBOutlet weak var yearlyButton: UIButton!
	@IBOutlet weak var yearlyButtonView: UIView!
	@IBOutlet weak var yearlyCircleButton: UIButton!
	@IBOutlet weak var yearlyCircleButtonView: UIView!
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	@IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func save(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func frequencySelectionReset() {
		tableView?.selectedFrequency = selectedFrequency
		tableView?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
		mainViewHeightConstraint.constant = 224.0
		containerViewHeightConstraint.constant = 0.0
		dailyButtonView.isHidden = false
		weeklyButtonView.isHidden = false
		monthlyButtonView.isHidden = false
		yearlyButtonView.isHidden = false
		let image = #imageLiteral(resourceName: "ic_done").withRenderingMode(.alwaysTemplate)
		dailyCircleButton.setImage(image, for: .normal)
		weeklyCircleButton.setImage(image, for: .normal)
		monthlyCircleButton.setImage(image, for: .normal)
		yearlyCircleButton.setImage(image, for: .normal)
		UIView.animate(withDuration: 0.5) {
			self.view.layoutIfNeeded()
		}
		selectedFrequency = .none
	}
	
	@IBAction func selectDaily(_ sender: UIButton) {
		if selectedFrequency != .none {
			frequencySelectionReset()
		} else {
			tableView?.selectedFrequency = .daily
			tableView?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
			mainViewHeightConstraint.constant = 56.0
			containerViewHeightConstraint.constant = 140.0
			weeklyButtonView.isHidden = true
			monthlyButtonView.isHidden = true
			yearlyButtonView.isHidden = true
			let image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
			dailyCircleButton.setImage(image, for: .normal)
			UIView.animate(withDuration: 0.5) {
				self.view.layoutIfNeeded()
			}
			selectedFrequency = .daily
			tableView?.selectedFrequency = selectedFrequency
			tableView?.tableView.reloadData()
		}
	}
	@IBAction func selectWeekly(_ sender: UIButton) {
		if selectedFrequency != .none {
			frequencySelectionReset()
		} else {
			tableView?.selectedFrequency = .weekly
			tableView?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
			mainViewHeightConstraint.constant = 56
			containerViewHeightConstraint.constant = 240.0
			dailyButtonView.isHidden = true
			monthlyButtonView.isHidden = true
			yearlyButtonView.isHidden = true
			let image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
			weeklyCircleButton.setImage(image, for: .normal)
			UIView.animate(withDuration: 0.5) {
				self.view.layoutIfNeeded()
			}
			selectedFrequency = .weekly
		}
	}
	@IBAction func selectMonthly(_ sender: UIButton) {
		if selectedFrequency != .none {
			frequencySelectionReset()
		} else {
			tableView?.selectedFrequency = .monthly
			tableView?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
			mainViewHeightConstraint.constant = 56
			containerViewHeightConstraint.constant = 140.0
			weeklyButtonView.isHidden = true
			dailyButtonView.isHidden = true
			yearlyButtonView.isHidden = true
			let image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
			monthlyCircleButton.setImage(image, for: .normal)
			UIView.animate(withDuration: 0.5) {
				self.view.layoutIfNeeded()
			}
			selectedFrequency = .monthly
		}
	}
	@IBAction func selectYearly(_ sender: UIButton) {
		if selectedFrequency != .none {
			frequencySelectionReset()
		} else {
			tableView?.selectedFrequency = .yearly
			tableView?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
			mainViewHeightConstraint.constant = 56
			containerViewHeightConstraint.constant = 140.0
			weeklyButtonView.isHidden = true
			monthlyButtonView.isHidden = true
			dailyButtonView.isHidden = true
			let image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
			yearlyCircleButton.setImage(image, for: .normal)
			UIView.animate(withDuration: 0.5) {
				self.view.layoutIfNeeded()
			}
			selectedFrequency = .yearly
		}
	}
	
	func setUpButton(_ view: UIView, button: UIButton, image: UIImage) {
		view.layer.cornerRadius = view.bounds.width / 2
		view.backgroundColor = Color.red
		button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
		button.tintColor = Color.white
		
		view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.bounds.width / 2).cgPath
		view.layer.shadowColor = view.backgroundColor?.cgColor
		view.layer.shadowRadius = 5
		view.layer.shadowOffset = CGSize(width: 1, height: 3)
		view.layer.shadowOpacity = 0.8
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
		
		containerViewHeightConstraint.constant = 0.0
		tableView?.tableView.isScrollEnabled = false
		setUpButton(dailyCircleButtonView, button: dailyCircleButton, image: #imageLiteral(resourceName: "ic_done"))
		setUpButton(weeklyCircleButtonView, button: weeklyCircleButton, image: #imageLiteral(resourceName: "ic_done"))
		setUpButton(monthlyCircleButtonView, button: monthlyCircleButton, image: #imageLiteral(resourceName: "ic_done"))
		setUpButton(yearlyCircleButtonView, button: yearlyCircleButton, image: #imageLiteral(resourceName: "ic_done"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "embed" {
			if let viewController = segue.destination as? RecurrenceTableViewController {
				self.tableView = viewController
			}
		}
    }

}
