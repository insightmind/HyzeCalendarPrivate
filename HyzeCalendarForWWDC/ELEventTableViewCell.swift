//
//  ELEventTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 05.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class ELEventTableViewCell: UITableViewCell {
    
    var event: EKEvent? = nil

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure() {
        backgroundColor = UIColor.clear
        mainView.layer.cornerRadius = 20
        let txtColor = Color.white.withAlphaComponent(0.7)
        startTime.textColor = txtColor
        endTime.textColor = txtColor
        titleLabel.textColor = Color.white
        
//        let path = UIBezierPath(roundedRect: mainView.bounds, cornerRadius: 20)
//        mainView.layer.shadowPath = path.cgPath
//        mainView.layer.shadowColor = Color.grey.cgColor
//        mainView.layer.shadowOpacity = 0.7
    }
    
    func loadDateTexts() {
        guard let secureEvent = event else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        startTime.text = dateFormatter.string(from: secureEvent.startDate)
        endTime.text = dateFormatter.string(from: secureEvent.endDate)
    }
    
    func loadCalendarColor() {
        guard let calendar = event?.calendar else { return }
        let color = UIColor(cgColor: calendar.cgColor)
        mainView.backgroundColor = color
    }
    
    func loadTitle() {
        guard let title = event?.title else { return }
        titleLabel.text = title
    }
    
    func loadEvent(_ event: EKEvent) {
        self.event = event
        loadDateTexts()
        loadTitle()
        loadCalendarColor()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}