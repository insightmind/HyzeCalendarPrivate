//
//  ELFreetimeTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 05.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class ELFreetimeTableViewCell: UITableViewCell {

    @IBOutlet weak var topVertSeperator: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomVertSeperator: UIView!
    
    var prevEvent: EKEvent?
    var futEvent: EKEvent?
    
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        topVertSeperator.layer.cornerRadius = topVertSeperator.bounds.width / 2
        bottomVertSeperator.layer.cornerRadius = bottomVertSeperator.bounds.width / 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadTime(_ minutes: Int) {
        if minutes < 53 { timeLabel.text = "" }
        let min = minutes % 60
        let hour = minutes / 60 - min
        if min == 0 {
            timeLabel.text = " \(hour)h"
        } else {
            timeLabel.text = " \(hour)h \(min)min"
        }
    }
    
}
