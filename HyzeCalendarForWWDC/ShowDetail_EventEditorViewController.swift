//
//  ShowDetail_EventEditorViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import UIKit

extension EventEditorViewController {
	
	func showDetailViewDidLoad () {
		showDetailSetUpTitleTextField()
		showDetailSetUpSaveButton()
	}
	
	func showDetailSetUpTitleTextField() {
		self.titleTextField.text = eventInformations.title
		self.titleTextField.isUserInteractionEnabled = false
	}
	
	func showDetailSetUpSaveButton() {
		saveButton.setTitle("Edit", for: .normal)
	}
	
}
