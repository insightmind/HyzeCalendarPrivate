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
    let smallFontSize = UIFont.systemFont(ofSize: 14)

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectMenu: UIView!
    
    func configure() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
        mainView.layer.cornerRadius = 20
        let txtColor = Color.white.withAlphaComponent(0.7)
        startTime.textColor = txtColor
        endTime.textColor = txtColor
        titleLabel.textColor = Color.white
        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = Color.grey.cgColor
        mainView.layer.shadowOpacity = 0.6
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 5
        selectMenu.layer.cornerRadius = selectMenu.frame.height / 2
    }
    
    func loadDateTexts() {
        guard let secureEvent = event else { return }
        if secureEvent.isAllDay == true {
            startTime.text = "all Day"
            endTime.text = ""
            return
        }
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
        if selected {
            selectMenu.isHidden = false
        } else {
            selectMenu.isHidden = true
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        return
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = "unable to load Event"
        startTime.text = ""
        endTime.text = ""
    }
    
}
