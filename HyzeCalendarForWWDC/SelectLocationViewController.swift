//
//  SelectLocationViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/5/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import EventKit

class Artwork: NSObject, MKAnnotation {
	let title: String?
	let coordinate: CLLocationCoordinate2D
	let subtitle: String?
	
	init(title: String, subtitle: String?, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.coordinate = coordinate
		self.subtitle = subtitle
		
		super.init()
	}
}

class SelectLocationViewController: PopoverViewController {
	
	var searchController: SelectLocationSearchViewController?
    var alarmViewController: AddAlarmViewController? {
        didSet {
            if alarmViewController == nil {
                hasAlarmContext = false
            } else {
                hasAlarmContext = true
            }
        }}
    private var hasAlarmContext: Bool = false

	@IBOutlet var popover: UIView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var mapViewAspectRatio: NSLayoutConstraint!
	@IBOutlet weak var mapViewOneOneAspectRatio: NSLayoutConstraint!
	@IBOutlet weak var mainContainerView: UIView!
	@IBOutlet weak var toolbar: UIView!
	@IBOutlet weak var blurView: UIVisualEffectView!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var mainBlurView: UIVisualEffectView!
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
    
	@IBAction func save(_ sender: UIButton) {
		guard let tableView = searchController?.tableViewController else { return }
		if let location = tableView.selectedLocation.first {
			let item = MKMapItem(placemark: location)
			let structuredLocation = EKStructuredLocation(mapItem: item)
			structuredLocation.title = location.title
            if hasAlarmContext {
                guard let alarmController = alarmViewController else { return }
                alarmController.location = structuredLocation
            } else {
                eventInformations.location = structuredLocation
            }
		} else {
            if hasAlarmContext {
                guard let alarmController = alarmViewController else { return }
                alarmController.location = nil
            } else {
                eventInformations.location = nil
            }
		}
		self.dismiss(animated: true, completion: {
            if !self.hasAlarmContext {
                guard let eventEditorTableView = self.eventInformations.eventEditorTableViewController else { return }
                eventEditorTableView.reloadCell(.location, onlyInformations: true)
            }
		})
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.clear
		popover.layer.cornerRadius = 20
		popover.layer.masksToBounds = true
		
		if Settings.shared.isDarkMode {
			self.popover.backgroundColor = Color.black.withAlphaComponent(0.3)
		} else {
			self.popover.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		}
		
		saveButton.isHidden = eventInformations.state == .showDetail ? true : false
		mainBlurView.effect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
		blurView.effect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
		
		if let location = eventInformations.location {
			if let geoLocation = location.geoLocation {
				let distance: CLLocationDistance = 1000
				let region = MKCoordinateRegionMakeWithDistance(geoLocation.coordinate, distance, distance * 0.7)
				mapView.setRegion(region, animated: true)
				let artwork = Artwork(title: location.title!, subtitle: nil, coordinate: geoLocation.coordinate)
				mapView.addAnnotation(artwork)
				mapView.showsUserLocation = true
			}
		} else if let location = LocationManagement.shared.locationManager.location {
			mapView.showsUserLocation = true
			let distance: CLLocationDistance = 1000
			let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance * 0.7)
			mapView.setRegion(region, animated: true)
		}
		
        // Do any additional setup after loading the view.
    }

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		if eventInformations.state == .showDetail {
			mapViewAspectRatio.isActive = false
			mapViewOneOneAspectRatio.isActive = true
		} else {
			mapViewAspectRatio.isActive = true
			mapViewOneOneAspectRatio.isActive = false
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "embed" {
			if let viewController = segue.destination as? SelectLocationSearchViewController {
				viewController.mapView = self.mapView
                viewController.alarmLocation = self.alarmViewController?.location
                viewController.hasAlarmContext = self.hasAlarmContext
				searchController = viewController
			}
		}
    }

}
