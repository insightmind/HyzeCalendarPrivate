//
//  SetContactsPopoverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SetContactsPopoverViewController: UIViewController {

	
	@IBOutlet weak var popoverView: UIView!
	@IBOutlet weak var backgroundBlurView: UIVisualEffectView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var toolbarBlurView: UIVisualEffectView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func saveButton(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

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
