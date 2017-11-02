//
//  EventRow.swift
//  Hyze Extension
//
//  Created by Niklas Bülow on 30.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import WatchKit
import Foundation

class EventRow: NSObject {


    @IBOutlet var eventTitle: WKInterfaceLabel!
    func setTitle(_ string: String?) {
        eventTitle.setText(string)
    }
}
