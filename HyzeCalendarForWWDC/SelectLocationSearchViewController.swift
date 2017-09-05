//
//  SelectLocationSearchViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 9/5/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SelectLocationSearchViewController: UIViewController, UISearchBarDelegate {

	@IBOutlet weak var searchBar: UISearchBar!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
		searchBar.delegate = self
    }
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		dismissKeyboard()
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
