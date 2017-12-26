//
//  LocationManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/5/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManagement {
	
	let locationManager = CLLocationManager()
	
	static let shared = LocationManagement()
	
	func getLocationInformations(location: CLLocation) -> ([String: String], [String]) {
		let geoCoder = CLGeocoder()
        var areaOfInterests = [String]()
		var placeInformations: [String: String] = [:]
		geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
			if error != nil {
				print("Could not reverse GeoLocation")
			} else {
				// Place details
				var placeMark: CLPlacemark!
				placeMark = placemarks?[0]
				
				// Location name
				if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
					placeInformations["name"] = String(locationName)
				}
				// Zip code
				if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
					placeInformations["zip"] = String(zip)
				}
				
				// City
				if let city = placeMark.addressDictionary!["City"] as? NSString {
					placeInformations["city"] = String(city)
				}
                
                // Area of Interests
                if let interests = placeMark.areasOfInterest {
                    areaOfInterests = interests
                }
				
				// Country
				if let country = placeMark.addressDictionary!["CountryCode"] as? NSString {
					placeInformations["country"] = String(country)
				}
			}
		})
		return (placeInformations, areaOfInterests)
	}
	
}
