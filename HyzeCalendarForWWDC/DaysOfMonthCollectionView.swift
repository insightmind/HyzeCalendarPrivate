//
//  DaysOfMonthCollectionView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/29/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DaysOfMonthCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	let reuseIdentifier = "day"
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		self.dataSource = self
		self.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.dataSource = self
		self.delegate = self
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.register(DaysOfMonthCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.allowsMultipleSelection = true
		return 31
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DaysOfMonthCollectionViewCell
		
		let label = UILabel(frame: cell.bounds)
		label.text = String(indexPath.item + 1)
		label.textAlignment = .center
		label.textColor = Color.white
		label.font = UIFont.init(name: "Futura", size: 20)
		cell.contentView.bounds = cell.contentView.bounds.insetBy(dx: 4, dy: 4)
		cell.contentView.layer.cornerRadius = cell.bounds.width / 2
		cell.contentView.layer.shadowPath = UIBezierPath(ovalIn: cell.contentView.bounds).cgPath
		cell.contentView.layer.shadowColor = Color.red.cgColor
		cell.contentView.layer.shadowOffset = CGSize(width: 1, height: 3)
		cell.contentView.layer.shadowRadius = 5
		cell.contentView.layer.shadowOpacity = 0
		cell.layer.masksToBounds = false
		cell.contentView.layer.masksToBounds = false
		
		cell.addSubview(label)
		
		let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label" : label])
		let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label" : label])
		
		NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width) / 7
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0.0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0.0
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		
		UIView.animate(withDuration: 0.4) {
			cell?.contentView.backgroundColor = Color.red
			cell?.contentView.layer.shadowOpacity = 0.8
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		UIView.animate(withDuration: 0.4) {
			cell?.contentView.backgroundColor = UIColor.clear
			cell?.contentView.layer.shadowOpacity = 0
		}
	}

}
