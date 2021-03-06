//
//  AlarmTableView.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 19.12.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

let defaultAlarmCellIdentifier = "defaultAlarmCell"

class AlarmTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let eventInformation = EventManagement.shared.eventInformation
    
    var alarms: [EKAlarm]?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
        self.allowsSelection = false
        self.isScrollEnabled = false
        
        self.backgroundColor = Color.blue
        
        let nib = UINib(nibName: "DefaultAlarmTableViewCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: defaultAlarmCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: defaultAlarmCellIdentifier) as! DefaultAlarmTableViewCell
        guard let alarm = alarms?[indexPath.row] else { return cell }
        cell.set(alarm: alarm)
        cell.tableView = self
        if eventInformation.state == .showDetail {
            cell.removeButtonView.isHidden = true
        } else {
            cell.removeButtonView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetch()
        return alarms?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func fetch() {
        alarms = eventInformation.alarms ?? []
    }
    
    func remove(alarm: EKAlarm) {
        guard var eAlarms = eventInformation.alarms else { return }
        var indexToRemove = 0
        for index in 0..<eAlarms.count {
            if alarm == eAlarms[index] {
                indexToRemove = index
                break
            }
        }
        
        eAlarms.remove(at: indexToRemove)
        eventInformation.alarms = eAlarms
        fetch()
        reloadData()
        
        guard let eventEditorTableView = eventInformation.eventEditorTableViewController else { return }
        eventEditorTableView.updateCellHeights()
        eventEditorTableView.reloadCell(.alarm, onlyInformations: true)
    }
    
}
