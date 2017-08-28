//
//  RecurrenceTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/27/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class RecurrenceTableViewController: UITableViewController {
	
	var eventInformations = EManagement.eventInformation
	var selectedFrequency: FrequencyType = .none
	var timeInterval: TimeIntervalTableViewCell?
	var weekDay: WeekdayTableViewCell?
	var endDate: DateTableViewCell?
	var popover: RecurrencePopoverViewController?
	
	var recurrenceEndType: RecurrenceEndType = .none
	
	enum RecurrenceCellTypes: String {
		case timeInterval = "timeInterval"
		case weekDay = "weekDay"
		case daysOfTheMonth = "daysOfTheMonth"
		case monthsOfTheYear = "monthsOfTheYear"
		case endDate = "endDate"
	}
	
	struct RecurrenceCells {
		let cellType: RecurrenceCellTypes
		var height: CGFloat
	}
	
	var cells: [RecurrenceCells] = []
	let timeIntervalCell = RecurrenceCells(cellType: .timeInterval, height: 140.0)
	var weekDayCell = RecurrenceCells(cellType: .weekDay, height: 88.0)
	var dateCell = RecurrenceCells(cellType: .endDate, height: 200.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		self.tableView.separatorStyle = .none
		self.tableView.allowsSelection = false
		self.tableView.register(UINib(nibName: "WeekdayTableViewCell", bundle: nil), forCellReuseIdentifier: RecurrenceCellTypes.weekDay.rawValue)
		self.tableView.register(UINib(nibName: "TimeIntervalTableViewCell", bundle: nil), forCellReuseIdentifier: RecurrenceCellTypes.timeInterval.rawValue)
		self.tableView.register(UINib(nibName: "DateTableViewCell", bundle: nil), forCellReuseIdentifier: RecurrenceCellTypes.endDate.rawValue)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.tableView.reloadData()
		self.tableView.layoutIfNeeded()
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
		switch selectedFrequency {
		case .none:
			return 0
		case .daily:
			return 2
		case .weekly:
			return 3
		case .monthly:
			return 2
		case .yearly:
			return 2
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch cells[indexPath.row].cellType {
		case .timeInterval:
			let cell = tableView.dequeueReusableCell(withIdentifier: RecurrenceCellTypes.timeInterval.rawValue) as! TimeIntervalTableViewCell
			cell.selectedFrequency = selectedFrequency
			cell.pickerView.reloadAllComponents()
			timeInterval = cell
	        return cell
		case .weekDay:
			let cell = tableView.dequeueReusableCell(withIdentifier: RecurrenceCellTypes.weekDay.rawValue) as! WeekdayTableViewCell
			cell.autoresizesSubviews = true
			weekDay = cell
			return cell
		case .daysOfTheMonth:
			fatalError()
		case .monthsOfTheYear:
			fatalError()
		case .endDate:
			let cell = tableView.dequeueReusableCell(withIdentifier: RecurrenceCellTypes.endDate.rawValue) as! DateTableViewCell
			cell.tableView = self
			endDate = cell
			return cell
		}
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		calculateCells()
		calculateEndDateHeight()
		if cells[indexPath.row].cellType == .endDate {
			switch recurrenceEndType {
			case .none:
				return 156
			case .date:
				fallthrough
			case .ocurrence:
				return 200
			}
		}
		return cells[indexPath.row].height
	}
	
	func calculateCells() {
		switch selectedFrequency {
		case .none:
			cells = []
		case .daily:
			cells = [timeIntervalCell,
					 dateCell]
		case .weekly:
			let weekDayHeight = 44 + (tableView.bounds.width - 40) / 7
			weekDayCell.height = weekDayHeight
			cells = [timeIntervalCell,
			         weekDayCell,
					 dateCell]
		case .monthly:
			cells = [timeIntervalCell,
					 dateCell]
		case .yearly:
			cells = [timeIntervalCell,
					 dateCell]
		}
	}
	
	func calculateEndDateHeight() {
		
		var height: CGFloat
		switch recurrenceEndType {
		case .none:
			height = 156
		case .date:
			fallthrough
		case .ocurrence:
			height = 200
		}
		var fullHeight: CGFloat = 0
		for i in 0..<cells.count {
			if cells[i].cellType == .endDate {
				cells[i].height = height
			}
			fullHeight += cells[i].height
		}
		popover!.containerViewHeightConstraint.constant = fullHeight
		UIView.animate(withDuration: 0.3, animations: {
			self.popover!.view.layoutIfNeeded()
		})
	}
	
	func updateCellHeights() {
		self.tableView.beginUpdates()
		self.tableView.endUpdates()
	}


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
