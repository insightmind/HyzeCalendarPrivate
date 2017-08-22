//
//  EKEventExtension.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import EventKit

extension EKEvent {
	func isReadOnly() -> Bool {
		var isReadOnly = false
		let title = self.title
		let checkTitle = "checkReadWriteAccess"
		
		self.title = checkTitle
		isReadOnly = title == self.title
		self.title = title
		
		print(isReadOnly)
		
		return isReadOnly
	}
}
