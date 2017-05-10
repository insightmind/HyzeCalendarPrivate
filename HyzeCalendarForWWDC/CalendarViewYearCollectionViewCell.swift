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
	}
	
	func initialize() {
		let collectionView = CalendarViewYearCollectionViewController(collectionViewLayout: CalendarViewFlowLayout())
		collectionView.view.frame = self.bounds
		self.addSubview(collectionView.view)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
