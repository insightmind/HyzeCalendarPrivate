//
//  DaysOfMonthCollectionViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/30/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DaysOfMonthCollectionViewCell: UICollectionViewCell {
	
	
	override func prepareForReuse() {
		for i in subviews {
			i.removeFromSuperview()
		}
	}
}
