//
//  EventEditorTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

enum EventEditorCellType: String {
	case dateSelection = "dateSelection"
	case calendar = "calendar"
	case contacts = "contacts"
	case notes = "notes"
	case remove = "remove"
	case recurrence = "recurrence"
	case location = "location"
    case colorPicker = "colorPicker"
    case alarm = "alarm"
}

struct EventEditorCellInformations {
	let cellType: EventEditorCellType
	let height: CGFloat
}

class EventEditorTableViewController: UITableViewController {
	
	var cells: [EventEditorCellInformations] = []
	
	let dateSelectionCell = EventEditorCellInformations(cellType: .dateSelection, height: 100.0)
	let calendarCell = EventEditorCellInformations(cellType: .calendar, height: 100.0)
	let contactsCell = EventEditorCellInformations(cellType: .contacts, height: 155.0)
	let notesCell = EventEditorCellInformations(cellType: .notes, height: 170.0)
	let removeCell = EventEditorCellInformations(cellType: .remove, height: 80.0)
	let recurrenceCell = EventEditorCellInformations(cellType: .recurrence, height: 212.0)
	let locationCell = EventEditorCellInformations(cellType: .location, height: 100.0)
    let colorPickerCell = EventEditorCellInformations(cellType: .colorPicker, height: 100.0)
    let alarmCell = EventEditorCellInformations(cellType: .alarm, height: 155.0)
	
	var eventsInformations: EventEditorEventInformations!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 50, right: 0)
		self.tableView.backgroundColor = UIColor.clear
		self.tableView.separatorStyle = .none
		self.tableView.allowsSelection = false

        self.tableView.showsVerticalScrollIndicator = false
		self.tableView.register(UINib(nibName: "DateSelectionTableViewCell", bundle: nil) ,forCellReuseIdentifier: EventEditorCellType.dateSelection.rawValue)
		self.tableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil) ,forCellReuseIdentifier: EventEditorCellType.notes.rawValue)
		self.tableView.register(UINib(nibName: "SelectCalendarTableViewCell", bundle: nil), forCellReuseIdentifier: EventEditorCellType.calendar.rawValue)
		self.tableView.register(UINib(nibName: "RemoveTableViewCell", bundle: nil), forCellReuseIdentifier: EventEditorCellType.remove.rawValue)
		self.tableView.register(UINib(nibName: "SelectContactsTableViewCell", bundle: nil), forCellReuseIdentifier: EventEditorCellType.contacts.rawValue)
		self.tableView.register(UINib(nibName: "SetRecurrenceTableViewCell", bundle: nil), forCellReuseIdentifier: EventEditorCellType.recurrence.rawValue)
		self.tableView.register(UINib(nibName: "SelectLocationTableViewCell", bundle: nil), forCellReuseIdentifier: EventEditorCellType.location.rawValue)
        self.tableView.register(UINib(nibName: "PickColorTableViewCell", bundle: nil), forCellReuseIdentifier: EventEditorCellType.colorPicker.rawValue)
        self.tableView.register(UINib(nibName: "AlarmTableViewCell", bundle: nil), forCellReuseIdentifier: EventEditorCellType.alarm.rawValue)
        
		self.eventsInformations = EventManagement.shared.eventInformation
		eventsInformations.eventEditorTableViewController = self
		
		self.updateCellsArray()
		
		hideKeyboardWhenTappedAround()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.tableView.reloadData()
	}
	


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch cells[indexPath.row].cellType {
		case .dateSelection:
			let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.dateSelection.rawValue) as! DateSelectionTableViewCell
			return cell
		case .notes:
			let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.notes.rawValue) as! NotesTableViewCell
			return cell
		case .calendar:
			let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.calendar.rawValue) as! SelectCalendarTableViewCell
			return cell
		case .remove:
			let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.remove.rawValue) as! RemoveTableViewCell
			return cell
		case .contacts:
			let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.contacts.rawValue) as! SelectContactsTableViewCell
			return cell
		case .recurrence:
			let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.recurrence.rawValue) as! SetRecurrenceTableViewCell
            cell.reloadInformations()
			return cell
		case .location:
			let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.location.rawValue) as! SelectLocationTableViewCell
			return cell
        case .colorPicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.colorPicker.rawValue) as! PickColorTableViewCell
            return cell
        case .alarm:
            let cell = tableView.dequeueReusableCell(withIdentifier: EventEditorCellType.alarm.rawValue) as! AlarmTableViewCell
            return cell
		}
    }
	
	func reloadCell(_ cellType: EventEditorCellType, onlyInformations: Bool) {
		for i in 0..<cells.count {
			if cells[i].cellType == cellType {
				let cellAtIndexPath = self.tableView.cellForRow(at: IndexPath(row: i, section: 0))
				switch cellType {
				case .dateSelection:
					let cell = cellAtIndexPath as! DateSelectionTableViewCell
					if onlyInformations {
						cell.reloadInformations()
					}
				case .calendar:
					let cell = cellAtIndexPath as! SelectCalendarTableViewCell
					if onlyInformations {
						cell.reloadInformations()
					}
				case .contacts:
					let cell = cellAtIndexPath as! SelectContactsTableViewCell
					if onlyInformations {
						cell.reloadInformations()
					}
				case .recurrence:
					let cell = cellAtIndexPath as! SetRecurrenceTableViewCell
					cell.setRoundView(cell.predefinedViews, shouldBeRounded: true)
					if onlyInformations {
						cell.reloadInformations()
					}
				case .location:
					let cell = cellAtIndexPath as! SelectLocationTableViewCell
					if onlyInformations {
						cell.reloadInformations()
					}
                case .colorPicker:
                    let cell = cellAtIndexPath as! PickColorTableViewCell
                    if onlyInformations {
                        cell.reloadInformations()
                    }
                case .alarm:
                    let cell = cellAtIndexPath as! AlarmTableViewCell
                    if onlyInformations {
                        cell.reloadInformations()
                    }
                    let indexPath = IndexPath(row: i, section: 0)
                    tableView.reloadRows(at: [indexPath], with: .none)
				default:
					return
				}
				
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch cells[indexPath.row].cellType {
		case .contacts:
			let (calculated, full) = calculateCellHeight(.contacts)
			return eventsInformations.showAllContacts ? full : calculated
        case .alarm:
            let (calculated, full) = calculateCellHeight(.alarm)
            return eventsInformations.showAllAlarms ? full : calculated
		case .recurrence:
			return calculateRecurrenceCellHeight()
		default:
			return cells[indexPath.row].height
		}
	}
	
	func updateCellsArray() {
		cells = []
		cells.append(dateSelectionCell)
        cells.append(colorPickerCell)
		cells.append(calendarCell)
		switch eventsInformations.state {
		case .showDetail:
			if eventsInformations.location != nil {
				cells.append(locationCell)
			}
			if let attendees = eventsInformations.participants {
				if !attendees.isEmpty {
					cells.append(contactsCell)
				}
			}
            if let alarms = eventsInformations.alarms {
                if !alarms.isEmpty {
                    cells.append(alarmCell)
                }
            }
			if eventsInformations.recurrenceRule != nil {
				cells.append(recurrenceCell)
			}
			if eventsInformations.notes != "" && eventsInformations.notes != nil {
				cells.append(notesCell)
			}
		case .create:
            cells.append(locationCell)
			cells.append(contactsCell)
            cells.append(recurrenceCell)
            cells.append(alarmCell)
			cells.append(notesCell)
			if eventsInformations.eventIdentifier != nil {
				cells.append(removeCell)
			}
		}
	}
	
    func calculateCellHeight(_ cellType: EventEditorCellType) -> (CGFloat, CGFloat){
		
		let normalHeight: CGFloat = 45
		let defaultCellHeight: CGFloat = 56
		var calculatedHeight = normalHeight
		var fullHeight = normalHeight
        
		switch eventsInformations.state {
		case .create:
			calculatedHeight += defaultCellHeight
			fullHeight += defaultCellHeight
            let count: Int
            switch cellType {
            case .alarm:
                guard let checkedCount = eventsInformations.alarms?.count else { return (calculatedHeight, fullHeight) }
                count = checkedCount
            case .contacts:
                guard let checkedCount = eventsInformations.participants?.count else { return (calculatedHeight, fullHeight) }
                count = checkedCount
            default:
                return (calculatedHeight, fullHeight)
            }
            fullHeight += defaultCellHeight * CGFloat(count)
            if count > 2 {
                fullHeight += defaultCellHeight
                calculatedHeight += 3 * defaultCellHeight
            } else {
                calculatedHeight += defaultCellHeight * CGFloat(count)
            }
		case .showDetail:
            let count: Int
            switch cellType {
            case .alarm:
                guard let checkedCount = eventsInformations.alarms?.count else { return (calculatedHeight, fullHeight) }
                count = checkedCount
            case .contacts:
                guard let checkedCount = eventsInformations.participants?.count else { return (calculatedHeight, fullHeight) }
                count = checkedCount
            default:
                return (calculatedHeight, fullHeight)
            }
            fullHeight += defaultCellHeight * CGFloat(count)
            if count > 3 {
                fullHeight += defaultCellHeight
                calculatedHeight += 4 * defaultCellHeight
            } else {
                calculatedHeight += defaultCellHeight * CGFloat(count)
            }
		}
		
		let heights = (calculatedHeight, fullHeight)
		
		return heights
	}
	
	func calculateRecurrenceCellHeight() -> CGFloat {
		switch eventsInformations.state {
		case .showDetail:
			return 100.0
		case .create:
			return 212.0
		}
	}
	
	func enlarge(_ shouldAddSpace: Bool) {
		self.tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top, left: 0, bottom: shouldAddSpace ? 450 : 50, right: 0)
		for index in 0..<cells.count {
			if cells[index].cellType == .notes {
				let indexPath = IndexPath(row: index, section: 0)
				self.tableView.scrollToRow(at: indexPath, at: shouldAddSpace ? .top : .bottom, animated: true)
			}
		}
		
	}
	
	func updateCellHeights() {
		tableView.beginUpdates()
		tableView.endUpdates()
	}

}
