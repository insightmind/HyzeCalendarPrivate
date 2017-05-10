//
//  CalendarViewMonthCollectionViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class CalendarViewMonthCollectionViewCell: UICollectionViewCell {
	lazy var collectionView: CalendarViewYear = {
		let cv = CalendarViewYear()
		return cv
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.contentMode = .center
		self.backgroundColor = UIColor.randomColor()
		self.collectionView.frame = self.bounds
		//let dayCellView = dayView(frame: self.bounds)
		self.contentView.layer.cornerRadius = self.bounds.width / 2
		//self.addSubview(dayCellView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func prepareForReuse() {
		self.backgroundColor = UIColor.randomColor()
	}
}
