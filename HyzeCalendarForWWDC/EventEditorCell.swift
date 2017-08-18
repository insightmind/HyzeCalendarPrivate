//
//  EventEditorCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/16/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation

protocol EventEditorCell {
	var eventInformations: EventEditorEventInformations! { get set }
	
	func reloadInformations()
	
}
