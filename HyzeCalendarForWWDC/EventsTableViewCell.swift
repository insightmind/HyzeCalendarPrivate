//
//  EventsTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/16/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class EventsTableViewCell: UITableViewCell {
    
    var title: String?
    var start: String!
    var end: String!
    var color: UIColor = UIColor.yellow
    var superEvent: EKEvent?
    
    lazy var inheritanceBar: UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 1
        return vw
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.baselineAdjustment = .alignCenters
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 2
        if darkMode {
            lbl.textColor = calendarWhite
        } else {
            lbl.textColor = calendarWhite
        }
        return lbl
    }()
    
    lazy var startLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var endLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setEditing(true, animated: false)
        self.backgroundColor = UIColor.clear
        self.addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendProperties(_ title: String = "unknown", from: Date, to: Date, color: UIColor = calendarOrange, inherit: EKEvent? = nil, isAllDay: Bool) {
        self.title = title
        
        if isAllDay {
            self.start = "full day"
            self.end = nil
        } else {
            let dateformatter = DateFormatter()
            if isAMPM {
                dateformatter.locale = Locale(identifier:  "en_US")
            } else {
                dateformatter.locale = Locale(identifier: "de_DE")
            }

            if TMCalendar.component(.day, from: from) != TMCalendar.component(.day, from: to) {
                dateformatter.dateStyle = .short
                dateformatter.timeStyle = .short
            } else {
                dateformatter.timeStyle = .short
            }
            self.start = "\(dateformatter.string(from: from))"
            self.end = "\(dateformatter.string(from: to))"
        }
        self.color = color
        self.superEvent = inherit
        if informationMode {
            print("[INFORMATION] \n EventsTableViewCell \n title:       \(title),\n startDate:   \(start ?? "noStartDate"),\n endDate:     \(end ?? "noEndDate"),\n color:       \(color),\n inheritFrom: \(String(describing: superEvent)) \n")
        }
        
        loadInformation()
    }
    
    func loadInformation() {
        
        self.accessoryType = .none
        
        self.inheritanceBar.backgroundColor = self.color
        self.titleLabel.text = self.title
        self.startLabel.text = self.start
        self.endLabel.text = self.end
        
        startLabel.textColor = UIColor.white
        endLabel.textColor = UIColor.white
        
        if darkMode {
            titleLabel.textColor = calendarWhite
        } else {
            titleLabel.textColor = calendarWhite
        }
        
    }
    
    func addSubviews() {
        
        self.contentView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)

        self.inheritanceBar.frame = CGRect(x: 5, y: 2, width: 2, height: 40)
        
        self.titleLabel.frame = CGRect(x: 15, y: 0, width: 1 * contentView.bounds.width / 2 - 7, height: contentView.bounds.height)
        
        self.startLabel.frame = CGRect(x: titleLabel.bounds.width + 10, y: 0, width: contentView.bounds.width / 2 - 7, height: contentView.bounds.height / 2 - 1)
        
        self.endLabel.frame = CGRect(x: titleLabel.bounds.width + 10, y: contentView.bounds.height / 2, width: contentView.bounds.width / 2 - 7, height: contentView.bounds.height / 2 - 1)
 
        self.contentView.addSubview(inheritanceBar)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(startLabel)
        self.contentView.addSubview(endLabel)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.inheritanceBar.bounds = CGRect(x: 5, y: 2, width: 2, height: 40)
		self.contentView.backgroundColor = UIColor.clear
    }

}
