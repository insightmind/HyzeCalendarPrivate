//
//  DefaultAlarmTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 19.12.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class DefaultAlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var removeButtonView: UIView!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var alarm: EKAlarm? {
        didSet {
            if alarm != nil {
                isConfigured = true
            } else {
                isConfigured = false
            }
        }
    }
    
    var isConfigured: Bool = false
    var tableView: AlarmTableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = Color.blue
        topLabel.textColor = Color.white
        
    }
    
    func set(alarm: EKAlarm) {
        if isConfigured { return }
        self.alarm = alarm
        if let date = alarm.absoluteDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            if Settings.shared.isAMPM {
                dateFormatter.locale = Locale(identifier: "en_US")
            } else {
                dateFormatter.locale = Locale(identifier: "de_DE")
            }
            let dateString = dateFormatter.string(from: date)
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            topLabel.text = dateString + " at " + dateFormatter.string(from: date)
        } else {
            topLabel.text = alarm.relativeOffset.formattedString() + " before"
        }
        
        if let location = alarm.structuredLocation {
            var actionString: String
            switch alarm.proximity {
            case .enter:
                actionString = "entering"
            case .leave:
                actionString = "leaving"
            case .none:
                bottomLabel.isHidden = true
                self.layoutIfNeeded()
                return
            }
           
            var locationString: String = "undefined"
            if let title = location.title  {
                locationString = title
            } else if let coreLocation = location.geoLocation {
                let (locationInformation, areaOfInterest) = LocationManagement.shared.getLocationInformations(location: coreLocation)
                if areaOfInterest.count == 0 {
                    if let safeString = locationInformation["name"] {
                        locationString = safeString
                    }
                } else {
                    if let area = areaOfInterest.first {
                        locationString = area
                    } else if let safeString = locationInformation["name"] {
                        locationString = safeString
                    }
                }
                
            }
            bottomLabel.text = actionString + " " + locationString
        } else {
            bottomLabel.isHidden = true
        }
        self.layoutIfNeeded()
    }
    
    func setUpDeleteButton() {
        self.removeButtonView.layer.cornerRadius = self.removeButtonView.bounds.width / 2
        self.removeButtonView.backgroundColor = Color.red
        let image = #imageLiteral(resourceName: "ic_delete").withRenderingMode(.alwaysTemplate)

        self.removeButton.setImage(image, for: .normal)
        self.removeButton.tintColor = Color.white
        
        self.removeButtonView.layer.shadowPath = UIBezierPath(roundedRect: removeButtonView.bounds, cornerRadius: removeButtonView.bounds.width / 2).cgPath
        self.removeButtonView.layer.shadowColor = self.removeButtonView.backgroundColor?.cgColor
        self.removeButtonView.layer.shadowRadius = 5
        self.removeButtonView.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.removeButtonView.layer.shadowOpacity = 0.8
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setUpDeleteButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func remove(_ sender: UIButton) {
        guard let tableView = tableView else { return }
        guard let alarm = alarm else { return }
        tableView.remove(alarm: alarm)
    }
    
    override func prepareForReuse() {
        self.isConfigured = false
    }
    
}
