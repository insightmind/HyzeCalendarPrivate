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
		let color = Color.white.withAlphaComponent(0.5)
		let str = NSAttributedString(string: "Untitled Event", attributes: [NSAttributedStringKey.foregroundColor : color])
		newEventTextField.attributedPlaceholder = str
	}
	
}
