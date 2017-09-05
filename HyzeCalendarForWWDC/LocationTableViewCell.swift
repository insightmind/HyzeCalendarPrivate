//
//  LocationTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/5/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var buttonView: UIView!
	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var address: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		mainView.backgroundColor = UIColor.clear
		self.backgroundColor = UIColor.clear
		setUpButton(buttonView, button: button, image: #imageLiteral(resourceName: "ic_add"))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
}
