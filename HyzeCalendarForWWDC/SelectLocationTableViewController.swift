//
//  SelectLocationTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/5/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import EventKit

class SelectLocationTableViewController: UITableViewController {
	
	var mapView: MKMapView?
	
	var eventInformations = EventManagement.shared.eventInformation
	let reuseIdentifier = "reuseCell"
	
	var locations: [MKPlacemark] = []
	var selectedLocation: [MKPlacemark] = []
    var alarmLocation: EKStructuredLocation? = nil
    var hasAlarmContext = false
	var withCurrentLocation = false
	var search = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		self.tableView.allowsSelection = false
		if eventInformations.state == .showDetail {
			self.tableView.isScrollEnabled = false
			self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
		} else {
			self.tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 45, right: 0)
		}
		let nib = UINib(nibName: "LocationTableViewCell", bundle: nil)
		self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
		self.tableView.backgroundColor = UIColor.clear
		self.tableView.separatorStyle = .none
        
        setSelectedLocation()
        
		self.searchDidChange("")
    }
    
    func setSelectedLocation() {
        var location: CLLocation?
        if hasAlarmContext {
            location = alarmLocation?.geoLocation
        } else {
            location = eventInformations.location?.geoLocation
        }
        if let checkedLocation = location {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(checkedLocation, completionHandler: { (placemarks, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let placemark = placemarks?.first {
                        let place = MKPlacemark(placemark: placemark)
                        self.selectLocation(place)
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if section == 0 {
			return selectedLocation.count
		}
		return locations.count
    }
	
	func searchDidChange(_ search: String) {
		self.search = search
		locations = []
		if eventInformations.state != .showDetail {
			if let currentLocation = LocationManagement.shared.locationManager.location {
				locations.append(MKPlacemark(coordinate: currentLocation.coordinate))
				withCurrentLocation = true
			} else {
				withCurrentLocation = false
			}
		} else {
			withCurrentLocation = false
		}
		let request = MKLocalSearchRequest()
		request.naturalLanguageQuery = search
		if let region = mapView?.region {
			request.region = region
		}
		let search = MKLocalSearch(request: request)
		search.start { (response, error) in
			if error != nil {
				self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
				print("Search could not be completed")
			} else {
				guard let items = response?.mapItems else { return }
				for item in items {
					if !self.selectedLocation.contains(item.placemark) {
						self.locations.append(item.placemark)
					}
				}
			}
			self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
		}
		
	}


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationTableViewCell
		if indexPath.section == 0 {
			if let location = selectedLocation.first {
				cell.setLocation(location)
			}
			cell.inSelection = true
			cell.backgroundColor = Color.blue
			cell.title.textColor = Color.white
			cell.address.textColor = Color.white.withAlphaComponent(0.7)
			cell.setUpButton(cell.buttonView, button: cell.button, image: eventInformations.state == .showDetail ? #imageLiteral(resourceName: "ic_pin_drop"): #imageLiteral(resourceName: "ic_delete"))
		} else {
			if indexPath.row == 0 && withCurrentLocation {
				if let location = LocationManagement.shared.locationManager.location {
					cell.setLocation(location, title: "Current Location")
				}
			} else {
				let location = locations[indexPath.row]
				cell.setLocation(location)
			}
			cell.inSelection = false
			cell.mainView.backgroundColor = UIColor.clear
			cell.backgroundColor = UIColor.clear
			cell.setUpButton(cell.buttonView, button: cell.button, image: #imageLiteral(resourceName: "ic_pin_drop"))
			cell.title.textColor = Settings.shared.isDarkMode ? Color.white : Color.blue
			cell.address.textColor = Settings.shared.isDarkMode ? Color.white.withAlphaComponent(0.7) : Color.blue.withAlphaComponent(0.7)
		}
        // Configure the cell...
		cell.tableView = self
        return cell
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
	
	func selectLocation(_ placemark: MKPlacemark) {
		selectedLocation = [placemark]
		for index in 0..<locations.count {
			if locations[index] == placemark {
				locations.remove(at: index)
				break
			}
		}
		self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
	}
	
	func deselectLocation() {
		selectedLocation = []
		searchDidChange(search)
		self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
