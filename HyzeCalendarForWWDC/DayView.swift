//
//  dayView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/30/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

enum watchHandType {
    case hour
    case minute
    case second
}

class DayView: UIView {
    
    enum stateType {
        case show
        case edit
    }
    
    let dayCenterButtonSpacing: CGFloat = 20
    var selectedEventIdentifier: String?
    var state: stateType = .show
    
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
                if Settings.shared.isAMPM {
                    str = String(12)
                    //str = "\(str)am"
                } else {
                    str = String(24)
                }
            } else if i > 12 {
                if Settings.shared.isAMPM {
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
    
    var hourDecoration = [DayViewDecoration]()

    var hourImage: UIImageView?
    var minuteImage: UIImageView?
    var secondImage: UIImageView?
    
    //in MIN 24*60 = 1440 min per Day
	var eventsOnDate: [String: [Int]]?
    var events = [EventView]()
	var processedEventsOnDate: [[String:[Int]]]!
    
    var superController: DayViewUIVViewController?
    var date: Date?
    
    
    lazy var dayViewCenterButton: DayMainButton = {
        let centerbutton = DayMainButton()
        return centerbutton
    }()
    
    func setDate(forDate: Date){
        date = forDate
    }
	
	func reloadData(animated: Bool = true) {
		
		for i in events {
			i.animate(.delete, duration: animated ? 0.3 : 0, delay: 0)
		}
		events = []
		setUp()
	}
    
    func setUp() {
		
		self.backgroundColor = UIColor.clear
		
        for i in self.subviews {
            self.willRemoveSubview(i)
            i.removeFromSuperview()
        }
        let (selectedYearID, selectedMonthID, indexPath) = Selection.shared.selectedDayCellIndex
        
        guard let selectedIndexPath = indexPath else {
            fatalError()
        }
		
		
		
        eventsOnDate = EventManagement.shared.convertEventsToTimeArray(EventManagement.shared.getEvents(for: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item)))
		processedEventsOnDate = prepareEventSubViewLayout()
        addEventsSubViews()
		setUpDayViewCenterButton()
		
        if Settings.shared.loaded {
            for i in 0...23 {
                Settings.shared.hourDecorationPosition.append(calculateHourLabelPosition(CGFloat(i)))
            }
            Settings.shared.loaded = false
        }
        setUpHourLabels()
        
        setUpWatchHand()
    }
    
    func calculateHourLabelPosition(_ hour: CGFloat) -> [CGFloat]{
        let angle = (CGFloat.pi*hour)/12
        let inset: CGFloat = 25
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
            self.hourLabel[i].center = CGPoint(x: Settings.shared.hourDecorationPosition[i][0], y: Settings.shared.hourDecorationPosition[i][1])
            self.hourLabel[i].font = UIFont.boldSystemFont(ofSize: self.hourLabel[i].bounds.height)
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
        let (selectedYearID, selectedMonthID, indexPath) = Selection.shared.selectedDayCellIndex
        
        guard let selectedIndexPath = indexPath else {
            fatalError()
        }
        if Settings.shared.isDarkMode {
            if TimeManagement.calendar.isDateInToday(TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item)){
                label.textColor = Color.white
            } else {
                label.textColor = Color.black
            }
        } else {
            if TimeManagement.calendar.isDateInToday(TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item)){
                label.textColor = Color.black
            } else {
                label.textColor = Color.white
            }
        }
		label.textColor = Color.white

    }
    
    func setUpTopLabel() {
        toggleIsTodayLabelColoring(self.topLabel)
        self.topLabel.frame = CGRect(
            x: self.dayViewCenterButton.bounds.width / 4,
            y: 2.75 * self.dayViewCenterButton.bounds.height / 10,
            width: 2 * self.dayViewCenterButton.bounds.width / 4,
            height: self.dayViewCenterButton.bounds.height / 10 + 3)
        self.topLabel.font = UIFont.boldSystemFont(ofSize: self.topLabel.bounds.height - 2)
        let (selectedYearID , selectedMonthID, _) = Selection.shared.selectedDayCellIndex
		self.topLabel.text = TimeManagement.getMonthName(TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: 1), withYear: false)
        self.dayViewCenterButton.addSubview(topLabel)
    }
    
    func setUpMidLabel() {
        toggleIsTodayLabelColoring(self.midLabel)
        self.midLabel.frame = CGRect(
            x: self.dayViewCenterButton.bounds.width / 4,
            y: 3.75 * self.dayViewCenterButton.bounds.height / 10,
            width:  2 * self.dayViewCenterButton.bounds.width / 4,
            height: self.dayViewCenterButton.bounds.height / 4)
        self.midLabel.font = UIFont.boldSystemFont(ofSize: self.midLabel.bounds.height - 5)
        let (_, _, indexPath) = Selection.shared.selectedDayCellIndex
        
        guard let selectedIndexPath = indexPath else {
            fatalError()
        }
		var text = ""
		
		switch selectedIndexPath.item {
		case 1:
			text = "1st"
		case 2:
			text = "2nd"
		case 3:
			text = "3rd"
		default:
			text = "\(selectedIndexPath.item)th"
		}
		
        self.midLabel.text = text
        self.dayViewCenterButton.addSubview(midLabel)
    }
    
    func setUpBotLabel() {
        toggleIsTodayLabelColoring(self.botLabel)
        self.botLabel.frame = CGRect(
            x: self.dayViewCenterButton.bounds.width / 4,
            y: 6.25 * self.dayViewCenterButton.bounds.height / 10,
            width: 2 * self.dayViewCenterButton.bounds.width / 4,
            height: self.dayViewCenterButton.bounds.height / 10)
        self.botLabel.font = UIFont.boldSystemFont(ofSize: self.botLabel.bounds.height)
        let (selectedYearID, _, _) = Selection.shared.selectedDayCellIndex
        self.botLabel.text = String(selectedYearID)
        self.dayViewCenterButton.addSubview(botLabel)
    }
	
	func prepareEventSubViewLayout() -> [[String: [Int]]] {
		let events = eventsOnDate ?? [String: [Int]]()
		if events.isEmpty {
			return [events]
		}
		var processedLayoutData: [[String: [Int]]] = [[String: [Int]]]()
		for event in events {
			var newLayer = false
			if processedLayoutData.isEmpty {
				processedLayoutData.append([event.key: event.value])
				if events.count <= 1 {
					return processedLayoutData
				}
			} else if event.value[0] == 0 {
				let newLayer = [event.key: event.value]
				processedLayoutData.insert(newLayer, at: 0)
			} else {
				for layer in 0...processedLayoutData.count - 1 {
					var fitsInLayer = false
					for processedEvent in processedLayoutData[layer] {
						if processedEvent.value[0] == 0 {
							fitsInLayer = false
							break
						} else if processedEvent.value[2] + 10 > event.value[1] && processedEvent.value[1] - 10 < event.value[2]{
							fitsInLayer = false
							break
						}
						fitsInLayer = true
					}
					if fitsInLayer {
						processedLayoutData[layer][event.key] = event.value
						break
					} else if layer == processedLayoutData.count - 1 {
						newLayer = true
					}
				}
				if newLayer {
					processedLayoutData.append([event.key: event.value])
				}
			}
		}
		return processedLayoutData
	}
    
    func addEventsSubViews(){
		if eventsOnDate!.count > 0 {
		for layer in 0...processedEventsOnDate.count - 1 {
			for i in processedEventsOnDate[layer] {
				if (i.value[1] <= i.value[2]) || i.value[0] == 0 {
					let event = EventView(frame: self.bounds , carcWidth: 5, eventIdentifier: i.key)
					event.drawLayer = layer
					event.sendTimeProperties(start: i.value[1], end: i.value[2])
					event.sendColorProperties(EventManagement.shared.getColor(eventIdentifier: event.eventIdentifier) ?? UIColor.randomColor())
					if i.value[0] == 0 {
						event.isFullDay = true
					}
					event.isEvent = true
					events.append(event)
					self.addSubview(event)
				} else {
					fatalError("Strange NormalEvent \(layer) with negative Duration, travelling back in Time is not allowed")
				}
			}
		}
			if Settings.shared.animateDayView {
				var i = events.count - 1
				while i >= 0 {
					let delay = events.count - 1 - i
					events[i].animate(.add, duration: 0.3, delay: 0.1 * Double(delay))
					i -= 1
				}
			} else {
				for i in 0...events.count - 1 {
					events[i].animate(.add, duration: 0, delay: 0)
				}
			}
        }
    }
    
    func setUpWatchHand() {
        
        if !Settings.shared.showWatchHands { return }
        if !TimeManagement.isSelectedToday() { return }
        
        loadWatchHandImageView(type: .hour)
        loadWatchHandImageView(type: .minute)
        loadWatchHandImageView(type: .second)
        
        animateWatchHand()
        
    }
    
    func animateWatchHand() {
            
        let radiant = 2*CGFloat.pi
        let hours: CGFloat = 24
        let minutes: CGFloat = 60
        let seconds: CGFloat = 60
        
        let hourRadians = radiant / (hours * minutes)
        let minuteRadians = radiant / minutes
        let secondRadians = radiant / seconds
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                
                guard let hour = self.hourImage else { return }
                guard let minute = self.minuteImage else { return }
                guard let second = self.secondImage else { return }
                
                if !TimeManagement.isSelectedToday() {
                    hour.removeFromSuperview()
                    minute.removeFromSuperview()
                    second.removeFromSuperview()
                    if let dayViewController = self.superController {
                        dayViewController.setDesign(animated: true)
                    }
                    timer.invalidate()
                }
                
                let now = Date()
                let currentHour = TimeManagement.calendar.component(.hour, from: now)
                let currentMinute = TimeManagement.calendar.component(.minute, from: now)
                let currentSecond = TimeManagement.calendar.component(.second, from: now)
                let both = currentHour * 60 + currentMinute
                
                UIView.animate(withDuration: 0.3, animations: {
                    hour.rotate(by: CGFloat(both) * hourRadians)
                    minute.rotate(by: CGFloat(currentMinute) * minuteRadians)
                })
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    second.rotate(by: CGFloat(currentSecond) * secondRadians)
                }, completion: nil)
            })
    }
    
    
    func loadWatchHandImageView(type: watchHandType) {
        
        var image: UIImage
        var rect: CGRect
        var color: UIColor
        switch type {
        case .hour:
            image = #imageLiteral(resourceName: "watchhand_bold")
            rect = self.bounds.insetBy(dx: 30, dy: 30)
            color = !Settings.shared.isDarkMode ? Color.white : Color.black
        case .minute:
            image = #imageLiteral(resourceName: "watchhand_bold")
            rect = self.bounds.insetBy(dx: 5, dy: 5)
            color = !Settings.shared.isDarkMode ? Color.white : Color.black
        case .second:
            image = #imageLiteral(resourceName: "watchhand")
            rect = self.bounds.insetBy(dx: -30, dy: -30)
            color = Color.red
        }
        // load WatchHandImage
        let templateImage = image.withRenderingMode(.alwaysTemplate)
        
        // setUp ImageView
        let imageView = UIImageView(image: templateImage)
        imageView.frame = rect
        imageView.tintColor = color
        
        imageView.layer.shadowColor = Color.black.cgColor
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowRadius = 5
        
        self.addSubview(imageView)
        
        switch type {
        case .hour:
            hourImage = imageView
        case .minute:
            minuteImage = imageView
        case .second:
            secondImage = imageView
        }
    }
	
	func getEventView(with eventIdentifier: String!) -> EventView? {
		for eventView in events {
			if eventView.eventIdentifier == eventIdentifier {
				return eventView
			}
		}
		return nil
	}
    
    func selectEventView(with stringIdentifier: String!, duration: TimeInterval = 0.2) {
		
		self.deselectEventView(with: selectedEventIdentifier)
		
		selectedEventIdentifier = stringIdentifier
		
		guard let eventView = getEventView(with: stringIdentifier) else {
			return
		}
        eventView.animate(.select, duration: duration)
		
    }
    
    func deselectEventView(with stringIdentifier: String!, duration: TimeInterval = 0.2) {
		guard let eventView = getEventView(with: stringIdentifier) else {
			return
		}
        eventView.animate(.deselect, duration: duration)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		eventsOnDate = [String: [Int]]()
    }
}
