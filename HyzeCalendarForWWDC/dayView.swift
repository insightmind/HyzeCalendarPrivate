//
//  dayView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/30/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class dayView: UIView {
    
    let dayCenterButtonSpacing: CGFloat = 20
    
    lazy var topLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    lazy var midLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    lazy var botLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var hourLabel: [UILabel] = {
        var lbl = [UILabel]()
        for i in 0...23 {
            let lbli = UILabel()
            var str: String
            if i == 0 {
                if isAMPM {
                    str = String(12)
                    //str = "\(str)am"
                } else {
                    str = String(0)
                }
            } else if i > 12 {
                if isAMPM {
                    str = String(i - 12)
                    //str = "\(str)pm"
                } else {
                    str = String(i)
                }
            } else {
                str = String(i)
                //str = "\(str)am"
            }
            
            if i%2 != 0 {
                lbli.isHidden = true
            }
            lbli.text = str
            lbli.textAlignment = .center
            lbli.adjustsFontSizeToFitWidth = true
            lbl.append(lbli)
        }
        return lbl
    }()
    
    var hourDecoration = [dayViewDecoration]()

    
    
    //in MIN 24*60 = 1440 min per Day
    var eventsOnDate: [[Int]]!
    var events = [EventView]()
    
    var date: Date?
    
    
    lazy var dayViewCenterButton: dayMainButton = {
        let centerbutton = dayMainButton()
        return centerbutton
    }()
    
    func setDate(forDate: Date){
        date = forDate
    }
    
    func setUp() {
        self.backgroundColor = UIColor.clear
        for i in self.subviews {
            self.willRemoveSubview(i)
            i.removeFromSuperview()
        }
        eventsOnDate = EManagement.convertEventsToTimeArray(EManagement.getEvents(for: TimeManagement.convertToDate(yearID: HSelection.selectedYearID, monthID: HSelection.selectedDayID, dayID: HSelection.selectedDayID)))
        addEventsSubViews()
        setUpDayViewCenterButton()
        if loaded {
            for i in 0...23 {
                hourDecorationPosition.append(calculateHourLabelPosition(CGFloat(i)))
            }
            loaded = false
        }
        setUpHourLabels()
        setUpDayViewDecoration()
    }
    
    func setUpDayViewDecoration(){
        for i in 0...23 {
            let deci: dayViewDecoration
            if i == 0 || i%6 == 0 {
                deci = dayViewDecoration.init(frame: self.dayViewCenterButton.bounds, arc: 10, inset: 10)
            } else if i%3 == 0{
                deci = dayViewDecoration.init(frame: self.dayViewCenterButton.bounds, arc: 7.5, inset: 10)
            } else {
                deci = dayViewDecoration.init(frame: self.dayViewCenterButton.bounds, arc: 5, inset: 10)
            }
            deci.sendIntProperties(start: i * 60)
            if i%1 != 0 {
                deci.isHidden = true
            }
            deci.backgroundColor = UIColor.clear
            if darkMode {
                if TMCalendar.isDateInToday(TimeManagement.convertToDate(yearID: HSelection.selectedYearID, monthID: HSelection.selectedDayID, dayID: HSelection.selectedDayID)) {
                    deci.sendColorProperties(CALENDARWHITE)
                } else {
                    deci.sendColorProperties(CALENDARGREY)
                }
            } else {
                if TMCalendar.isDateInToday(TimeManagement.convertToDate(yearID: HSelection.selectedYearID, monthID: HSelection.selectedDayID, dayID: HSelection.selectedDayID)) {
                    deci.sendColorProperties(CALENDARGREY)
                } else {
                    deci.sendColorProperties(CALENDARWHITE)
                }
            }
            self.hourDecoration.append(deci)
        }
        for i in 0..<hourDecoration.count {
            self.dayViewCenterButton.addSubview(hourDecoration[i])
        }
    }
    
    func calculateHourLabelPosition(_ hour: CGFloat) -> [CGFloat]{
        let angle = (PI*hour)/12
        let inset: CGFloat = 50
        let width = self.dayViewCenterButton.bounds.width
        let height = self.dayViewCenterButton.bounds.height
        let xFactor = (width - inset) / 2
        let yFactor = (height - inset) / 2
        let xOrigin = width / 2
        let yOrigin = height / 2
        let x: CGFloat = xFactor * sin(angle) + xOrigin
        let y: CGFloat = yFactor * -cos(angle) + yOrigin
        return [x,y]
    }
    
    func setUpHourLabels() {
        for i in 0..<hourLabel.count {
            toggleIsTodayLabelColoring(hourLabel[i])
            self.hourLabel[i].frame = CGRect(
                x: 0,
                y: 0,
                width: self.dayViewCenterButton.bounds.width / 4,
                height: self.dayViewCenterButton.bounds.height / 15)
            self.hourLabel[i].center = CGPoint(x: hourDecorationPosition[i][0], y: hourDecorationPosition[i][1])
            self.hourLabel[i].font = UIFont(descriptor: self.hourLabel[i].font.fontDescriptor, size: self.hourLabel[i].bounds.height)
            self.dayViewCenterButton.addSubview(hourLabel[i])
        }
    }
    
    func setUpDayViewCenterButton(){
        self.dayViewCenterButton.frame = self.bounds.insetBy(dx: dayCenterButtonSpacing, dy: dayCenterButtonSpacing)
        self.dayViewCenterButton.layer.cornerRadius = self.dayViewCenterButton.bounds.width / 2
        self.addSubview(dayViewCenterButton)
        setUpTopLabel()
        setUpMidLabel()
        setUpBotLabel()
    }
    
    func toggleIsTodayLabelColoring(_ label: UILabel) {
        if darkMode {
            if TMCalendar.isDateInToday(TimeManagement.convertToDate(yearID: HSelection.selectedYearID, monthID: HSelection.selectedDayID, dayID: HSelection.selectedDayID)){
                label.textColor = CALENDARWHITE
            } else {
                label.textColor = CALENDARGREY
            }
        } else {
            if TMCalendar.isDateInToday(TimeManagement.convertToDate(yearID: HSelection.selectedYearID, monthID: HSelection.selectedDayID, dayID: HSelection.selectedDayID)){
                label.textColor = CALENDARGREY
            } else {
                label.textColor = CALENDARWHITE
            }
        }

    }
    
    func setUpTopLabel() {
        toggleIsTodayLabelColoring(self.topLabel)
        self.topLabel.frame = CGRect(
            x: self.dayViewCenterButton.bounds.width / 4,
            y: 2.75 * self.dayViewCenterButton.bounds.height / 10,
            width: 2 * self.dayViewCenterButton.bounds.width / 4,
            height: self.dayViewCenterButton.bounds.height / 10)
        self.topLabel.font = UIFont(descriptor: self.topLabel.font.fontDescriptor, size: self.topLabel.bounds.height)
        self.topLabel.text = monthName[HSelection.selectedMonthID - 1]
        self.dayViewCenterButton.addSubview(topLabel)
    }
    
    func setUpMidLabel() {
        toggleIsTodayLabelColoring(self.midLabel)
        self.midLabel.frame = CGRect(
            x: self.dayViewCenterButton.bounds.width / 4,
            y: 3.75 * self.dayViewCenterButton.bounds.height / 10,
            width:  2 * self.dayViewCenterButton.bounds.width / 4,
            height: self.dayViewCenterButton.bounds.height / 4)
        self.midLabel.font = UIFont(descriptor: self.midLabel.font.fontDescriptor, size: self.midLabel.bounds.height)
        self.midLabel.text = String(HSelection.selectedDayID)
        self.dayViewCenterButton.addSubview(midLabel)
    }
    
    func setUpBotLabel() {
        toggleIsTodayLabelColoring(self.botLabel)
        self.botLabel.frame = CGRect(
            x: self.dayViewCenterButton.bounds.width / 4,
            y: 6.25 * self.dayViewCenterButton.bounds.height / 10,
            width: 2 * self.dayViewCenterButton.bounds.width / 4,
            height: self.dayViewCenterButton.bounds.height / 10)
        self.botLabel.font = UIFont(descriptor: self.botLabel.font.fontDescriptor, size: self.botLabel.bounds.height)
        self.botLabel.text = String(HSelection.selectedYearID)
        self.dayViewCenterButton.addSubview(botLabel)
    }
    
    func addEventsSubViews(){
        var viewID = 0
        for i in eventsOnDate {
            if i[0] == 0 {
                let eventInset = self.bounds.insetBy(dx: CGFloat(-4 * viewID - 15), dy:CGFloat(-4 * viewID - 15))
                let event = EventView(frame: eventInset , carcWidth: 5, addShadow: false)
                event.sendTimeProperties(start: i[1], end: i[2])
                event.sendColorProperties(eventsColorsOnSelectedDate[viewID])
                events.append(event)
                self.addSubview(event)
                viewID = viewID + 1
            }
        }
        for i in eventsOnDate {
            if i[0] == 1 {
            if i[1] <= i[2] {
                let event = EventView(frame: self.bounds, carcWidth: 25, addShadow: false)
                    event.sendTimeProperties(start: i[1], end: i[2])
                    event.sendColorProperties(eventsColorsOnSelectedDate[viewID])
                    events.append(event)
                    self.addSubview(event)
                } else {
                    fatalError("Strange NormalEvent \(viewID) with negative Duration, travelling back in Time is not allowed")
                }
                viewID = viewID + 1
            }
        }
        if TMCalendar.isDateInToday(TimeManagement.convertToDate(yearID: HSelection.selectedYearID, monthID: HSelection.selectedDayID, dayID: HSelection.selectedDayID)) == true {
            let watchhand = EventView(frame: self.bounds, carcWidth: 50, hourRotation: true)
            watchhand.sendTimeProperties(start: timeNowRadiant(), end: timeNowRadiant() + 10)
            watchhand.sendColorProperties(UIColor.red)
            self.addSubview(watchhand)
        }
    }
    
    func selectEventView(_ index: Int, duration: TimeInterval = 0.2) {
        let eventView = events[index]
        eventView.animate(.select, duration: duration)
    }
    
    func deselectEventView(_ index: Int, duration: TimeInterval = 0.2) {
        let eventView = events[index]
        eventView.animate(.deselect, duration: duration)
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        eventsOnDate = [[Int]]()
    }
}
