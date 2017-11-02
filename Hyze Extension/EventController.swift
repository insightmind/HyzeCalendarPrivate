//
//  EventController.swift
//  Hyze Extension
//
//  Created by Niklas Bülow on 02.11.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import EventKit
import WatchKit

class EventController: WKInterfaceController {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var startTime: WKInterfaceLabel!
    @IBOutlet var endTime: WKInterfaceLabel!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    func setEvent(_ event: EKEvent) {
        setUpTitle(event.title)
        titleLabel.setTextColor(UIColor(cgColor: event.calendar.cgColor))
        startTime.setText(event.startDate.stringIn(dateStyle: .medium, timeStyle: .medium))
        endTime.setText(event.endDate.stringIn(dateStyle: .medium, timeStyle: .medium))
    }
    
    private func setUpTitle(_ string: String) {
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let string = NSAttributedString(string: string, attributes: [NSAttributedStringKey.font: font])
        titleLabel.setAttributedText(string)
    }
    
}
