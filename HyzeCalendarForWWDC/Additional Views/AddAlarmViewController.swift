//
//  AddAlarmViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 24.12.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class AddAlarmViewController: PopoverViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    enum stateType {
        case date
        case time
    }
    
    private var state: stateType = .date
    var location: EKStructuredLocation? = nil {
        didSet {
            if location == nil {
                locationType = .none
            } else {
                locationType = .enter
            }
            setLocationTitle()
            setLocationHeight()
            setLocationSettings()
        }
    }
    private var locationType: EKAlarmProximity = .enter
    private var timeInterval: TimeInterval = 0

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var addLocationView: UIView!
    @IBOutlet weak var addLocationLabel: UILabel!
    @IBOutlet weak var addLocationSecondaryLabel: UILabel!
    @IBOutlet weak var addLocationButtonView: UIView!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var locationSettingsView: UIView!
    @IBOutlet weak var arriveButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var locationViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let effect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
        blurView.effect = effect
        
        
        mainView.layer.cornerRadius = 20
        mainView.layer.masksToBounds = true
        
        setUpDatePicker()
        setUpTimePicker()
        setUpLocation()
        setLayout()
        
    }
    
    func setUpLocation() {
        
        locationView.backgroundColor = Color.lightBlue
        locationView.layer.cornerRadius = 15
        locationView.layer.masksToBounds = true
        
        addLocationView.setUpButton(addLocationButtonView, button: addLocationButton, image: #imageLiteral(resourceName: "ic_add"))
        addLocationView.backgroundColor = UIColor.clear
        addLocationView.layer.cornerRadius = locationView.layer.cornerRadius
        
        setLocationHeight()
        setLocationSettings()
        setLocationTitle()
    }
    
    func setLocationSettings() {
        switch locationType {
        case .leave:
            leaveButton.backgroundColor = Color.lightBlue
            arriveButton.backgroundColor = Color.blue
        default:
            arriveButton.backgroundColor = Color.lightBlue
            leaveButton.backgroundColor = Color.blue
        }
    }
    
    func setLocationTitle() {
        if location == nil {
            addLocationLabel.text = "add Location"
            addLocationSecondaryLabel.isHidden = true
            let image = #imageLiteral(resourceName: "ic_add").withRenderingMode(.alwaysTemplate)
            addLocationButton.setImage(image, for: .normal)
        } else {
            setLocation()
            addLocationSecondaryLabel.isHidden = false
            let image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
            addLocationButton.setImage(image, for: .normal)
        }
    }
    
    func setLocationHeight(_ animated: Bool = false) {
        if location == nil {
            locationViewHeightConstraint.constant = 60
            locationSettingsView.isHidden = true
        } else {
            locationViewHeightConstraint.constant = 110
            locationSettingsView.isHidden = false
        }
        if !animated {
            view.layoutIfNeeded()
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setLocation() {
        guard let coreLocation = location?.geoLocation else { return }
        if let title = location?.title {
            if title.contains(",") {
                let splittedTitle = title.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: true)
                self.addLocationSecondaryLabel.isHidden = false
                self.addLocationLabel.text = String(splittedTitle[0])
                self.addLocationSecondaryLabel.text = String(splittedTitle[1])
            } else {
                self.addLocationLabel.text = title
                self.addLocationSecondaryLabel.isHidden = true
            }
        } else {
            let (locationInformation, areaOfInterests) = LocationManagement.shared.getLocationInformations(location: coreLocation)
            if let interest = areaOfInterests.first {
                addLocationLabel.text = interest
                guard let name = locationInformation["name"] else {
                    addLocationSecondaryLabel.isHidden = true
                    return
                }
                addLocationSecondaryLabel.isHidden = false
                addLocationSecondaryLabel.text = name
            } else if let name = locationInformation["name"] {
                if name.contains(",") {
                    let splittedTitle = name.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: true)
                    self.addLocationSecondaryLabel.isHidden = false
                    self.addLocationLabel.text = String(splittedTitle[0])
                    self.addLocationSecondaryLabel.text = String(splittedTitle[1])
                } else {
                    self.addLocationLabel.text = name
                    self.addLocationSecondaryLabel.isHidden = true
                }
            }
        }
    }
    
    func setUpDatePicker() {
        datePicker.maximumDate = eventInformations.startDate
        let yearsInSeconds = 315576000
        datePicker.minimumDate = eventInformations.startDate.addingTimeInterval(TimeInterval(-yearsInSeconds))
        datePicker.countDownDuration = 1
        
        datePicker.setDate(eventInformations.startDate, animated: false)
        
        if Settings.shared.isAMPM {
            datePicker.locale = Locale(identifier: "en_US")
        } else {
            datePicker.locale = Locale(identifier: "de_DE")
        }
        
        datePicker.setValue(Settings.shared.isDarkMode ? Color.white : Color.black, forKey: "textColor")
    }
    
    func setUpTimePicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func setLayout() {
        switch state {
        case .date:
            setDateLayout()
        case .time:
            setTimeLayout()
        }
    }
    
    func setDateLayout() {
        dateButton.backgroundColor = Color.lightBlue
        timeButton.backgroundColor = Color.blue
        
        datePicker.isHidden = false
        pickerView.isHidden = true
        
        middleLabel.text = String(TimeManagement.calendar.component(.year, from: datePicker.date))
    }
    
    func setTimeLayout() {
        dateButton.backgroundColor = Color.blue
        timeButton.backgroundColor = Color.lightBlue
        
        datePicker.isHidden = true
        pickerView.isHidden = false
        
        middleLabel.text = "before event"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        
        
        var alarm: EKAlarm
        switch state {
        case .date:
            alarm = EKAlarm(absoluteDate: datePicker.date)
        case .time:
            alarm = EKAlarm(relativeOffset: timeInterval)
        }
        alarm.structuredLocation = location
        alarm.proximity = locationType
        if let _ = eventInformations.alarms {
            eventInformations.alarms?.append(alarm)
        } else {
            eventInformations.alarms = [alarm]
        }
        eventInformations.eventEditor?.reloadTableViewCells(.alarm, onlyInformations: true)
        eventInformations.eventEditorTableViewController?.updateCellHeights()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setDate(_ sender: UIButton) {
        state = .date
        setLayout()
    }
    
    @IBAction func setTime(_ sender: UIButton) {
        state = .time
        setLayout()
    }
    
    @IBAction func changeValue(_ sender: UIDatePicker) {
        switch state {
        case .date:
            middleLabel.text = String(TimeManagement.calendar.component(.year, from: datePicker.date))
        default:
            break
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 1000
        case 2:
            return 24
        case 4:
            return 60
        default:
            return 1
        }
    }
    
    @IBAction func setArrive(_ sender: UIButton) {
        locationType = .enter
        setLocationSettings()
    }
    @IBAction func setLeave(_ sender: UIButton) {
        locationType = .leave
        setLocationSettings()
    }
    
    @IBAction func setLocation(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SelectLocation", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        guard let locationViewController = viewController as? SelectLocationViewController else { return }
        locationViewController.alarmViewController = self
        self.present(locationViewController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddAlarmViewController {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let color = Settings.shared.isDarkMode ? Color.white : Color.black
        if component % 2 == 0 {
            let text = NSAttributedString(string: String(row), attributes: [NSAttributedStringKey.foregroundColor: color])
            return text
        } else {
            let string = component == 1 ? "d" : (component == 3 ? "h" : "m")
            return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let days = pickerView.selectedRow(inComponent: 0) * 24 * 60 * 60
        let hours = pickerView.selectedRow(inComponent: 2) * 60 * 60
        let minutes = pickerView.selectedRow(inComponent: 4) * 60
        let seconds = TimeInterval((days + hours + minutes))
        timeInterval = -seconds
        middleLabel.text = seconds.formattedString()
    }
}
