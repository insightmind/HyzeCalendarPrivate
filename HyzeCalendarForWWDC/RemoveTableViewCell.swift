//
//  RemoveTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/19/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class RemoveTableViewCell: UITableViewCell, EventEditorCell {
	
	var eventInformations: EventEditorEventInformations! = EventManagement.shared.eventInformation
	
	func reloadInformations() {
		eventInformations = EventManagement.shared.eventInformation
		return
	}

	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var removeButton: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		self.backgroundColor = UIColor.clear
		
		mainView.backgroundColor = Color.red
		mainView.layer.cornerRadius = mainView.bounds.height / 2
		mainView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func remove(_ sender: UIButton) {
		guard let viewController = self.eventInformations.eventEditor else {
			fatalError()
		}
		let alert = UIAlertController(title: "Remove Event?", message: "You can't undo this action! ", preferredStyle: .alert)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
			return
		}
		let remove = UIAlertAction(title: "Remove", style: .destructive) { (_) in
			EventManagement.shared.deleteEvent(self.eventInformations)
			viewController.endEditingWithReload()
		}
		alert.addAction(cancel)
		alert.addAction(remove)
		
		viewController.present(alert, animated: true, completion: nil)
	}
	
}
