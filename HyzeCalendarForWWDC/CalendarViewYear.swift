//
//  CalendarViewYear.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class CalendarViewYear: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

	//Constant for Size of Cells and Header
	var cellSize: CGSize?
	
	let reuseIdentifier = "monthcell"
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
		dataSource = self
		delegate = self
		self.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		let sizeA = collectionView.bounds.size.width - 25
		cellSize = CGSize(width: sizeA , height: sizeA)
		
		collectionView.register(CalendarViewMonthCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		return 12
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CalendarViewMonthCollectionViewCell
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return cellSize!
		
	}


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
