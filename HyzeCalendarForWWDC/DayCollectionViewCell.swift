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
		lbl.textColor = CALENDARWHITE
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
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
