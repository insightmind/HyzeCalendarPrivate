//
//  Create_EventEditorViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import UIKit

extension EventEditorViewController {
	
	func createViewDidLoad () {
		
		var color: UIColor
		
		if darkMode {
			color = Color.white.withAlphaComponent(0.5)
		} else {
			color = Color.grey.withAlphaComponent(0.5)
		}
		
		let str = NSAttributedString(string: "Untitled Event", attributes: [NSAttributedStringKey.foregroundColor : color])
		titleTextField.attributedPlaceholder = str
	}
	
	func createSetUpSaveButton() {
		saveButton.setTitle("Save", for: .normal)
	}
	
}
