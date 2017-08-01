//
//  DateSelectionTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DateSelectionTableViewCell: UITableViewCell {

	// - MARK: Outlets
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet var startDateLabels: [UILabel]!
	@IBOutlet var endDateLabels: [UILabel]!
	
	@IBAction func startDateTap(_ sender: UIButton) {
		if var topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			let storyBoard = UIStoryboard(name: "Starts", bundle: nil)
			guard let startDateViewController = storyBoard.instantiateInitialViewController() else {
				return
			}
			startDateViewController.modalTransitionStyle = .coverVertical
			topController.present(startDateViewController, animated: true, completion: nil)
		}
	}
	
	@IBAction func endDateTap(_ sender: UIButton) {
		if var topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			let storyBoard = UIStoryboard(name: "Ends", bundle: nil)
			guard let endDateViewController = storyBoard.instantiateInitialViewController() else {
				return
			}
			endDateViewController.modalTransitionStyle = .coverVertical
			topController.present(endDateViewController, animated: true, completion: nil)
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.backgroundColor = UIColor.clear
		
		mainView.backgroundColor = calendarBlue
		mainView.layer.cornerRadius = mainView.frame.height / 2
		mainView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
