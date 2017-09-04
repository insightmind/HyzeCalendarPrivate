//
//  DaysOfMonthCollectionView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/29/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DaysOfMonthCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	var eventInformations = EventManagement.shared.eventInformation
	
	let reuseIdentifier = "day"
	var selectedCells: [NSNumber]?
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		self.dataSource = self
		self.delegate = self
		self.selectedCells = []
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.dataSource = self
		self.delegate = self
		
		guard let rule = eventInformations.recurrenceRule else { return }
		self.selectedCells = rule.daysOfTheMonth
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
		cell.contentView.backgroundColor = Color.blue
		cell.contentView.bounds = cell.contentView.bounds.insetBy(dx: 4, dy: 4)
		cell.contentView.layer.cornerRadius = cell.bounds.width / 2
		cell.layer.shadowPath = UIBezierPath(ovalIn: cell.contentView.bounds).cgPath
		cell.layer.shadowColor = Color.red.cgColor
		cell.layer.shadowOffset = CGSize(width: 1, height: 3)
		cell.layer.shadowRadius = 5
		cell.layer.shadowOpacity = 0
		cell.layer.masksToBounds = false
		cell.contentView.layer.masksToBounds = false
		
		cell.addSubview(label)
		
		let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[superview]-(<=1)-[label]", options: .alignAllCenterY, metrics: nil, views: ["superview": cell, "label" : label])
		let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[superview]-(<=1)-[label]", options: .alignAllCenterX, metrics: nil, views: ["superview": cell, "label" : label])
		
		NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
		let number = NSNumber(integerLiteral: indexPath.item + 1)
		if let selection = selectedCells {
			if selection.contains(number) {
				cell.contentView.backgroundColor = Color.red
				cell.layer.shadowOpacity = 0.8
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			let horizontalSpacing = flowLayout.minimumInteritemSpacing
			let cellWidth = (UIScreen.main.bounds.width - max(0, 6 - 1)*horizontalSpacing)/7
			let size = CGSize(width: cellWidth, height: cellWidth)
			return size
		}
		let width = collectionView.bounds.width / 7
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 4.0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0.0
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		
		let prevBounds = cell.contentView.bounds
		let prevPath = cell.layer.shadowPath
		cell.contentView.bounds = CGRect.zero
		cell.layer.shadowPath = UIBezierPath(ovalIn: CGRect.zero).cgPath
		cell.contentView.layer.cornerRadius = 0
		
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
			
			cell.contentView.backgroundColor = Color.red
			cell.contentView.layer.cornerRadius = prevBounds.width / 2
			cell.contentView.bounds = prevBounds
			cell.layer.shadowPath = prevPath
			cell.layer.shadowOpacity = 0.8
			
		}, completion: nil)
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		UIView.animate(withDuration: 0.2) {
			cell?.contentView.backgroundColor = Color.blue
			cell?.layer.shadowOpacity = 0
		}
	}

}
