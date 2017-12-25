//
//  TimeIntervalExtension.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 21.12.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func formattedString() -> String {
        let seconds = self
        let m = (Int(seconds) / 60)
        let h = (m / 60)
        var days = (h / 24)
        var hours = h - days * 24
        var minutes = m - h * 60
        
        var string = ""
        if days < 0 {
            days *= -1
        }
        if minutes < 0 {
            minutes *= -1
        }
        if hours < 0 {
            hours *= -1
        }
        
        if days > 0 {
            string += "\(days) " + (days == 1 ? "day" : "days")
        }
        if hours > 0 {
            string += " \(hours) " + (hours == 1 ? "hour" : "hours")
        }
        if minutes > 0 {
            string += " \(minutes) " + (minutes == 1 ? "minute" : "minutes")
        }
        return string
    }
    
    
}
