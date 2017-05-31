//
//  CalendarViewDayCollectionViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit


class DayCollectionViewCell: UICollectionViewCell {
	
	var label: UILabel?
	var configured: Bool = false
	
	lazy var lbl: UILabel = {
		let lbl = UILabel()
		lbl.text = "0"
		if darkMode {
			lbl.textColor = CALENDARWHITE
		} else {
			lbl.textColor = CALENDARGREY
		}
		
		lbl.textAlignment = .center
		return lbl
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.contentMode = .center
		//let dayCellView = dayView(frame: self.bounds)
		self.contentView.layer.cornerRadius = self.bounds.width / 2
		//self.addSubview(dayCellView)
		self.configured = true
		if self.label == nil {
			self.lbl.contentMode = .center
			self.lbl.frame = self.bounds
			self.addSubview(lbl)
			self.label = lbl
		} else {
			self.label!.text = ""
		}
	}
	
	func setCellDesign(isToday: Bool, isSelected: Bool) {
		self.isSelected = isSelected
		if isSelected {
			contentView.backgroundColor = CALENDARORANGE
			if isToday {
				label?.textColor = CALENDARORANGE
			} else {
				if darkMode {
					label?.textColor = CALENDARWHITE
				} else {
					label?.textColor = CALENDARGREY
				}
			}
		} else {
			if isToday {
				label?.textColor = CALENDARORANGE
				if darkMode {
					contentView.backgroundColor = CALENDARGREY
				} else {
					contentView.backgroundColor = CALENDARWHITE
				}
			} else {
				if darkMode {
					contentView.backgroundColor = CALENDARGREY
					label?.textColor = CALENDARWHITE
				} else {
					contentView.backgroundColor = CALENDARWHITE
					label?.textColor = CALENDARGREY
				}
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
