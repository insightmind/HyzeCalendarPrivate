//
//  RecurrenceDaysOfMonthPickerView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/30/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class RecurrenceDaysOfMonthPickerView: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
	
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		var string = ""
		if component == 0 {
			string = zeroStrings[row]
		} else {
			string = oneString[row]
		}
		return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: Color.white])
	}
	
	let zeroStrings = ["first",
	                   "second",
	                   "third",
	                   "fourth",
	                   "fifth",
	                   "last"]
	
	var oneString: [String] = []
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == 0 {
			return zeroStrings.count
		} else {
			oneString = []
			let dateFormatter = DateFormatter()
			for i in 0...6 {
				var index = i + Selection.shared.weekDayStart.rawValue
				if index > 6 {
					index -= 7
				}
				oneString.append(dateFormatter.weekdaySymbols[index])
			}
			oneString.append("day")
			oneString.append("weekday")
			oneString.append("weekend day")
			return oneString.count
		}
	}
	
}
