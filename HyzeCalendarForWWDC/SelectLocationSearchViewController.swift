//
//  SelectLocationSearchViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/5/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import MapKit

class SelectLocationSearchViewController: UIViewController, UISearchBarDelegate {

	
	var eventInformations = EventManagement.shared.eventInformation
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var blurView: UIVisualEffectView!
	
	var mapView: MKMapView?
	var tableViewController: SelectLocationTableViewController?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
		searchBar.delegate = self
		let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
		textFieldInsideSearchBar?.textColor = Settings.shared.isDarkMode ? Color.white : Color.black
		
		blurView.effect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
		
		if eventInformations.state == .showDetail {
			searchBar.isHidden = true
			blurView.isHidden = true
		}
    }
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		dismissKeyboard()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateSearch), object: nil)
		self.perform(#selector(updateSearch), with: nil, afterDelay: 0.5)
	}
	
	@objc func updateSearch() {
		tableViewController?.searchDidChange(searchBar.text ?? "")
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
			if let viewController = segue.destination as? SelectLocationTableViewController {
				viewController.mapView = self.mapView
				tableViewController = viewController
			}
		}
    }


}
