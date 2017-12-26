//
//  SelectLocationTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/4/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import MapKit

class SelectLocationTableViewCell: UITableViewCell, EventEditorCellProtocol {
	

	var eventInformations: EventEditorEventInformations! = EventManagement.shared.eventInformation
	
	func reloadInformations() {
        self.selectButtonView.isHidden = false
        var isRealLocation: Bool = false
        if let location = eventInformations.location?.geoLocation {
			let geoCoder = CLGeocoder()
			var place: MKPlacemark?
			geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
				if let e = error {
					print(e.localizedDescription)
				} else {
					if let placemark = placemarks?.first {
						place = MKPlacemark(placemark: placemark)
					}
				}
				if let title = place?.title {
					if title.contains(",") {
						let splittedTitle = title.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: true)
						self.label.text = String(splittedTitle[0])
						self.subLabel.text = String(splittedTitle[1])
						self.subLabel.isHidden = false
					} else {
						self.label.text = title
						self.subLabel.isHidden = true
					}
				}
			})
            isRealLocation = true
			setUpButton(selectButtonView, button: selectButton, image: #imageLiteral(resourceName: "ic_edit"))
            self.layoutIfNeeded()
		} else {
			label.text = "add Location"
			subLabel.isHidden = true
			setUpButton(selectButtonView, button: selectButton, image: #imageLiteral(resourceName: "ic_add"))
            self.layoutIfNeeded()
		}
        if let title = eventInformations.location?.title {
            self.label.text = title
            self.subLabel.isHidden = true
            if eventInformations.state == .showDetail {
                self.selectButtonView.isHidden = isRealLocation ? false : true
            } else {
                self.selectButtonView.isHidden = false
            }
        }
        self.layoutIfNeeded()
	}
	
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var topViewLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var selectButtonView: UIView!
	@IBOutlet weak var selectButton: UIButton!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var subLabel: UILabel!
	@IBOutlet var labelHeightConstraint: NSLayoutConstraint!
	
	@IBAction func edit(_ sender: UIButton) {
		LocationManagement.shared.locationManager.requestWhenInUseAuthorization()
		let storyboard = UIStoryboard(name: "SelectLocation", bundle: nil)
		guard let viewController = storyboard.instantiateInitialViewController() else { return }
		guard let mainViewController = eventInformations.eventEditor else { return }
		mainViewController.present(viewController, animated: true, completion: nil)
	}
	
	override func layoutIfNeeded() {
        expandLabel(subLabel.isHidden)
		super.layoutIfNeeded()
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		backgroundColor = UIColor.clear
		
		cellView.layer.cornerRadius = topView.bounds.height / 2
		cellView.layer.masksToBounds = true
		
		reloadInformations()
		
		if eventInformations.state == .showDetail {
			setUpButton(selectButtonView, button: selectButton, image: #imageLiteral(resourceName: "ic_keyboard_arrow_right"))
		}
    }
	
	func expandLabel(_ expand: Bool) {
		if expand {
            subLabel.isHidden = true
		} else {
            subLabel.isHidden = false
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        reloadInformations()
    }
    
    override func prepareForReuse() {
        reloadInformations()
    }
    
}
