//
//  LocationTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/5/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationTableViewCell: UITableViewCell {
	
	var eventInformations = EventManagement.shared.eventInformation

	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var buttonView: UIView!
	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var address: UILabel!
	var tableView: SelectLocationTableViewController?
	var placemark: MKPlacemark?
	var inSelection: Bool = false
	
	override func awakeFromNib() {
        super.awakeFromNib()
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
	
	@IBAction func toggleSelection(_ sender: UIButton) {
		if eventInformations.state == .showDetail {
			jumpToLocation()
		} else if inSelection {
			removeLocation()
		} else {
			addLocation()
		}
	}
	
	func removeLocation() {
		guard let superController = tableView else { return }
		superController.deselectLocation()
		guard let map = superController.mapView else { return }
		map.removeAnnotations(map.annotations)
	}
	
	func jumpToLocation() {
		guard let superController = tableView else { return }
		guard let securePlacemark = placemark else { return }
		guard let secureLocation = securePlacemark.location?.coordinate else { return }
		guard let map = superController.mapView else { return }
		let distance: CLLocationDistance = 600
		let region = MKCoordinateRegionMakeWithDistance(secureLocation, distance, distance * 0.7)
		map.setRegion(region, animated: true)
		map.removeAnnotations(map.annotations)
		if let currentLocation = LocationManagement.shared.locationManager.location {
			if secureLocation.latitude == currentLocation.coordinate.latitude && secureLocation.longitude == currentLocation.coordinate.longitude {
				return
			}
		}
		var pin: Artwork = Artwork(title: "Unknown Location", subtitle: nil, coordinate: secureLocation)
		guard let secureTitle = self.title.text else { return }
		pin = Artwork(title: secureTitle, subtitle: self.address.text, coordinate: secureLocation)
		map.addAnnotation(pin)
	}
	
	func addLocation() {
		guard let superController = tableView else { return }
		guard let securePlacemark = placemark else { return }
		superController.selectLocation(securePlacemark)
		jumpToLocation()
	}
	
	func setLocation(_ location: CLLocation, title: String? = nil) {
		
		let geoCoder = CLGeocoder()
		geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
			if let e = error {
				print("Could not reverse GeoLocation" + e.localizedDescription)
			} else {
				// Place details
				var placeMark: CLPlacemark!
				placeMark = placemarks?[0]
				self.placemark = MKPlacemark(placemark: placeMark)
				
				var subtitle = " "
				
				// Location name
				if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
					if let secureTitle = title {
						self.title.text = secureTitle
						subtitle += "\(String(locationName)), "
					} else {
						self.title.text = String(locationName)
					}
				}
				// Zip code
				if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
					subtitle += String(zip)
				}
				
				// City
				if let city = placeMark.addressDictionary!["City"] as? NSString {
					subtitle += " " + String(city) + ","
				}
				
				// Country
				if let country = placeMark.addressDictionary!["CountryCode"] as? NSString {
					subtitle += " " + String(country)
				}
				
				self.address.text = subtitle
				
				guard let _ = self.placemark else {
					self.title.text = "Unknown location"
					self.address.text = "No location was associated"
					return
				}
			}
		})
	}
	
	func setLocation(_ placemark: MKPlacemark, title: String? = nil) {
		self.placemark = placemark
		if let secureTitle = title {
			self.title.text = secureTitle
			if let name = placemark.title {
				self.address.text = name
			}
		} else {
			if let name = placemark.title {
				if name.contains(",") {
					let splittedTitle = name.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: true)
					self.title.text = String(splittedTitle[0])
					self.address.text = String(splittedTitle[1])
				} else {
					self.title.text = name
				}
			}
		}
	}

	override func prepareForReuse() {
		title.text = "Update Location"
		address.text = "LocationSearch is in progress!"
		placemark = nil
		isSelected = false
	}


}
