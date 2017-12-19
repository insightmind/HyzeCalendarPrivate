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
        
        let nib = UINib(nibName: "DefaultAlarmTableViewCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: defaultAlarmCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: defaultAlarmCellIdentifier) as! DefaultAlarmTableViewCell
        cell.topLabel.text = String(describing: alarms![indexPath.row].absoluteDate)
        cell.bottomLabel.text = String(describing: alarms![indexPath.row].relativeOffset)
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
    
}
