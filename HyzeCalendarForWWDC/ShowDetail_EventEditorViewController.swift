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
		self.newEventTextField.text = eventInformations.title
		self.newEventTextField.isUserInteractionEnabled = false
	}
	
}
