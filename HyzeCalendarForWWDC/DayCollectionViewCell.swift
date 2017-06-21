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
		if darkMode {
			lbl.textColor = calendarWhite
		} else {
			lbl.textColor = calendarGrey
		}
		lbl.font = UIFont.init(name: "Futura", size: 16)
		lbl.textAlignment = .center
		return lbl
	}()
    
    lazy var bline: UIView = {
        let vw = UIView()
        if darkMode {
            vw.backgroundColor = UIColor.lightGray
        } else {
            vw.backgroundColor = UIColor.darkGray
        }
        return vw
    }()
	
	fileprivate func setUpShadow() {
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2)
		layer.masksToBounds = false
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
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
		self.isSelected = isSelected
        if isSelected {
			if isOnWeekend {
				contentView.backgroundColor = calendarGreen
			} else {
				contentView.backgroundColor = calendarBlue
			}
            if isToday {
                label?.textColor = calendarOrange
            } else {
                if darkMode {
                    label?.textColor = calendarWhite
                } else {
                    label?.textColor = calendarWhite
                }
            }
        } else {
			self.contentView.backgroundColor = UIColor.clear
			layer.shadowOpacity = 0
            if isToday {
                label?.textColor = calendarOrange
            } else {
				if isOnWeekend {
					label?.textColor = calendarGreen
				} else {
					label?.textColor = calendarBlue
				}
            }
        }
        if isNotInMonth {
            label?.textColor = label?.textColor.withAlphaComponent(0.3)
        }
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
