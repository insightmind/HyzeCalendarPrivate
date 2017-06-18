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
			lbl.textColor = CALENDARWHITE
		} else {
			lbl.textColor = CALENDARGREY
		}
		lbl.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
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
	
    func setCellDesign(isToday: Bool, isSelected: Bool, isNotInMonth: Bool = false) {
		self.isSelected = isSelected
        if isSelected {
            contentView.backgroundColor = CALENDARORANGE
            if isToday {
                label?.textColor = CALENDARORANGE
            } else {
                if darkMode {
                    label?.textColor = CALENDARWHITE
                } else {
                    label?.textColor = CALENDARGREY
                }
            }
        } else {
            if isToday {
                label?.textColor = CALENDARORANGE
                if darkMode {
                    contentView.backgroundColor = CALENDARGREY
                } else {
                    contentView.backgroundColor = CALENDARWHITE
                }
            } else {
                if darkMode {
                    contentView.backgroundColor = CALENDARGREY
                    label?.textColor = CALENDARWHITE
                } else {
                    contentView.backgroundColor = CALENDARWHITE
                    label?.textColor = CALENDARGREY
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
