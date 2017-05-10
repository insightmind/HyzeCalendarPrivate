//
//  CalendarViewYearCollectionViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class CalendarViewYearCollectionViewCell: UICollectionViewCell {

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.randomColor()
		let collectionView = CalendarViewMonthCollectionViewCell(frame: self.bounds)
		//self.addSubview(dayCellView)
		self.addSubview(collectionView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.backgroundColor = UIColor.randomColor()
		let collectionView = CalendarViewMonthCollectionViewCell(frame: self.bounds)
		//self.addSubview(dayCellView)
		self.addSubview(collectionView)
	}
	
	override func prepareForReuse() {
		self.backgroundColor = UIColor.randomColor()
	}
}
