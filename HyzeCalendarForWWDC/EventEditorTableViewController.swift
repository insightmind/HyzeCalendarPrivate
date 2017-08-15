//
//  EventEditorTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

enum EventEditorCellType {
	case dateSelection
	case notes
}

struct EventEditorCellInformations {
	let cellType: EventEditorCellType
	let height: CGFloat
}

class EventEditorTableViewController: UITableViewController {
	
	var cells: [EventEditorCellInformations] = [EventEditorCellInformations(cellType: .dateSelection, height: 100.0),
	                                            EventEditorCellInformations(cellType: .notes, height: 170.0)]
	var eventsInformations: EventEditorEventInformations!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		self.tableView.backgroundColor = UIColor.clear
		self.tableView.separatorStyle = .none
		self.tableView.allowsSelection = false
		self.tableView.register(UINib(nibName: "DateSelectionTableViewCell", bundle: nil) ,forCellReuseIdentifier: "dateSelection")
		self.tableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil) ,forCellReuseIdentifier: "notes")
		
		self.eventsInformations = EventEditorViewController.getEventsInformations()
		
		switch eventsInformations.state {
		case .showDetail:
			if eventsInformations.notes == "" || eventsInformations.notes == nil {
				for i in 0..<cells.count {
					if cells[i].cellType == .notes {
						cells.remove(at: i)
					}
				}
			}
		default:
			break
		}
		
		hideKeyboardWhenTappedAround()
    }
	


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 108, right: 0)
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch cells[indexPath.row].cellType {
		case .dateSelection:
			let cell = tableView.dequeueReusableCell(withIdentifier: "dateSelection") as! DateSelectionTableViewCell
			return cell
		case .notes:
			let cell = tableView.dequeueReusableCell(withIdentifier: "notes") as! NotesTableViewCell
			return cell
		}
		
    }
	
	func reloadCell(_ cellType: EventEditorCellType, onlyInformations: Bool) {
		for i in 0..<cells.count {
			if cells[i].cellType == cellType {
				switch cellType {
				case .dateSelection:
					let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! DateSelectionTableViewCell
					if onlyInformations {
						cell.reloadInformations()
					}
				default:
					return
				}
				
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch cells[indexPath.row].cellType {
		case .dateSelection:
			fallthrough
		default:
			return cells[indexPath.row].height
		}
	}

}
