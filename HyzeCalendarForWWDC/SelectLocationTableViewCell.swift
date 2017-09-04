//
//  SelectLocationTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/4/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SelectLocationTableViewCell: UITableViewCell, EventEditorCellProtocol {
	

	var eventInformations: EventEditorEventInformations! = EventManagement.shared.eventInformation
	
	func reloadInformations() {
		return
	}
	
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var topViewLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var selectButtonView: UIView!
	@IBOutlet weak var selectButton: UIButton!
	@IBOutlet weak var label: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		backgroundColor = UIColor.clear
		
		cellView.layer.cornerRadius = topView.bounds.height / 2
		cellView.layer.masksToBounds = true
		
		if let location = eventInformations.location {
			label.text = location
			setUpButton(selectButtonView, button: selectButton, image: #imageLiteral(resourceName: "ic_edit"))
		} else {
			label.text = "add Location"
			setUpButton(selectButtonView, button: selectButton, image: #imageLiteral(resourceName: "ic_add"))
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
