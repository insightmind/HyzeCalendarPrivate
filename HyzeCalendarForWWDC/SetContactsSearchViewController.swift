//
//  SetContactsSearchViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SetContactsSearchViewController: UIViewController, UISearchBarDelegate {

	@IBOutlet weak var searchBar: UISearchBar!
	
	var tableViewController: SetContactsTableViewController?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		searchBar.delegate = self
		self.view.backgroundColor = UIColor.clear
		self.searchBar.barTintColor = Color.lightBlue
		self.searchBar.searchBarStyle = .minimal
		let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
		textFieldInsideSearchBar?.textColor = Settings.shared.isDarkMode ? Color.white : Color.black
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		// to limit network activity, reload half a second after last key press.
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateSearch), object: nil)
		self.perform(#selector(updateSearch), with: nil, afterDelay: 0.5)
	}
	
	@objc func updateSearch() {
		tableViewController?.searchDidChange(searchBar.text ?? "")
	}
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		self.view.endEditing(true)
	}
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "embed" {
			guard let viewController = segue.destination as? SetContactsTableViewController else {
				return
			}
			viewController.searchBar = searchBar
			self.tableViewController = viewController
		}
    }


}
