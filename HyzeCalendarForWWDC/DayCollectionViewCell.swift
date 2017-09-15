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
    var isSelectable: Bool = true
    var bottomLine: UIView?
	
	lazy var lbl: UILabel = {
		let lbl = UILabel()
		lbl.text = "0"
		if Settings.shared.isDarkMode {
			lbl.textColor = Color.white
		} else {
			lbl.textColor = Color.grey
		}
		lbl.textAlignment = .center
		return lbl
	}()
    
    lazy var bline: UIView = {
        let vw = UIView()
        if Settings.shared.isDarkMode {
            vw.backgroundColor = UIColor.lightGray
        } else {
            vw.backgroundColor = UIColor.darkGray
        }
        return vw
    }()
	
	fileprivate func setUpShadow() {
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2)
		layer.masksToBounds = false
		layer.shadowColor = self.contentView.backgroundColor?.cgColor
		layer.shadowRadius = 10
		layer.shadowOffset = CGSize(width: 0, height: 4.0)
		if isSelected {
			layer.shadowOpacity = 0.5
		} else {
			layer.shadowOpacity = 0
		}
		layer.shadowPath = shadowPath.cgPath
	}
	
	fileprivate func setUpContentView() {
		self.contentMode = .center
		self.contentView.layer.cornerRadius = self.bounds.width / 2
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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpContentView()
		setUpShadow()
	}
	
	func setCellDesign(isToday: Bool, isSelected: Bool, isNotInMonth: Bool = false, isOnWeekend: Bool = false) {
		label!.font = UIFont.init(name: "Futura", size: 17)
		self.isSelected = isSelected
        if isSelected {
			layer.shadowOpacity = 0.85
			if isOnWeekend {
				contentView.backgroundColor = Color.green
			} else {
				contentView.backgroundColor = Color.blue
			}
            if isToday {
                contentView.backgroundColor = Color.red
            }
			label?.textColor = Color.white
        } else {
			self.contentView.backgroundColor = UIColor.clear
			layer.shadowOpacity = 0
            if isToday {
                label?.textColor = Color.red
            } else {
				if isOnWeekend {
					label?.textColor = Color.green
				} else {
					label?.textColor = Color.blue
				}
            }
        }
        if isNotInMonth {
            label?.textColor = label?.textColor.withAlphaComponent(0.3)
        }
		layer.shadowColor = self.contentView.backgroundColor?.cgColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
