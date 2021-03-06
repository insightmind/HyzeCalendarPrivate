//
//  CalendarViewMonthCollectionViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
	
	var controller: MonthCollectionViewController?
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		self.layer.masksToBounds = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func prepareForReuse() {
		controller!.removeFromParentViewController()
		self.viewWithTag(69)?.removeFromSuperview()
		controller = nil
	}
}
