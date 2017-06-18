//
//  CalendarViewYearCollectionViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class YearCollectionViewCell: UICollectionViewCell {

	var controller: YearCollectionViewController?

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func prepareForReuse() {
		controller!.removeFromParentViewController()
		for i in self.subviews {
			i.removeFromSuperview()
		}
		controller = nil
	}
}
