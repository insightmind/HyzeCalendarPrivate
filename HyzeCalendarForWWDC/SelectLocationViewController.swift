//
//  SelectLocationViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/5/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import MapKit

class Artwork: NSObject, MKAnnotation {
	let title: String?
	let coordinate: CLLocationCoordinate2D
	
	init(title: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.coordinate = coordinate
		
		super.init()
	}
}

class SelectLocationViewController: UIViewController {
	
	var eventInformations = EventManagement.shared.eventInformation


	@IBOutlet var popover: UIView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var mainContainerView: UIView!
	@IBOutlet weak var toolbar: UIView!
	@IBOutlet weak var blurView: UIVisualEffectView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var mainBlurView: UIVisualEffectView!
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.clear
		popover.layer.cornerRadius = 20
		popover.layer.masksToBounds = true
		
		if Settings.shared.isDarkMode {
			self.popover.backgroundColor = Color.grey.withAlphaComponent(0.3)
		} else {
			self.popover.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		}
		
		mainBlurView.effect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
		blurView.effect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
		
		guard let location = eventInformations.location else { return }
		guard let geoLocation = location.geoLocation else { return }
		
		mapView.setCenter(geoLocation.coordinate, animated: true)
		let distance: CLLocationDistance = 1000
		let region = MKCoordinateRegionMakeWithDistance(geoLocation.coordinate, distance, distance * 0.7)
		mapView.setRegion(region, animated: true)
		let artwork = Artwork(title: location.title!, coordinate: geoLocation.coordinate)
		mapView.addAnnotation(artwork)
		
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
