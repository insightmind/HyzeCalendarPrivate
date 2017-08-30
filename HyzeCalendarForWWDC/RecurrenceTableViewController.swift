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
	var daysOfMonth: DaysOfMonthTableViewCell?
	var daysOfMonthPicker: DaysOfMonthPickerTableViewCell?
	var monthsOfYear: MonthsOfYearTableViewCell?
	var popover: RecurrencePopoverViewController?
	
	var recurrenceEndType: RecurrenceEndType = .none
	
	enum RecurrenceCellTypes: String {
		case timeInterval = "timeInterval"
		case weekDay = "weekDay"
		case daysOfTheMonth = "daysOfTheMonth"
		case monthsOfTheYear = "monthsOfTheYear"
		case daysOfTheMonthPicker = "daysOfTheMonthPicker"
		case endDate = "endDate"
	}
	
	struct RecurrenceCells {
		let cellType: RecurrenceCellTypes
		let height: CGFloat
	}
	
	var cells: [RecurrenceCells] = []
	let timeIntervalCell = RecurrenceCells(cellType: .timeInterval, height: 140.0)
	var weekDayCell = RecurrenceCells(cellType: .weekDay, height: 88.0)
	let daysOfMonthCell = RecurrenceCells(cellType: .daysOfTheMonth, height: 324.0)
	let daysOfMonthPickerCell = RecurrenceCells(cellType: .daysOfTheMonthPicker, height: 100.0)
	var daysOfMonthPickerExpanded: Bool = false
	let monthsOfYearCell = RecurrenceCells(cellType: .monthsOfTheYear, height: 185.0)
	let dateCell = RecurrenceCells(cellType: .endDate, height: 280.0)
	var dateCellExpanded: Bool = false

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
		self.tableView.register(UINib(nibName: "DaysOfMonthTableViewCell", bundle: nil), forCellReuseIdentifier: RecurrenceCellTypes.daysOfTheMonth.rawValue)
		self.tableView.register(UINib(nibName: "MonthsOfYearTableViewCell", bundle: nil), forCellReuseIdentifier: RecurrenceCellTypes.monthsOfTheYear.rawValue)
		self.tableView.register(UINib(nibName: "DaysOfMonthPickerTableViewCell", bundle: nil), forCellReuseIdentifier: RecurrenceCellTypes.daysOfTheMonthPicker.rawValue)
    }
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
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
			return 3
		case .yearly:
			return 4
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
			let cell = tableView.dequeueReusableCell(withIdentifier: RecurrenceCellTypes.daysOfTheMonth.rawValue) as! DaysOfMonthTableViewCell
			daysOfMonth = cell
			return cell
		case .monthsOfTheYear:
			let cell = tableView.dequeueReusableCell(withIdentifier: RecurrenceCellTypes.monthsOfTheYear.rawValue) as! MonthsOfYearTableViewCell
			monthsOfYear = cell
			return cell
		case .endDate:
			let cell = tableView.dequeueReusableCell(withIdentifier: RecurrenceCellTypes.endDate.rawValue) as! DateTableViewCell
			cell.tableView = self
			endDate = cell
			return cell
		case .daysOfTheMonthPicker:
			let cell = tableView.dequeueReusableCell(withIdentifier: RecurrenceCellTypes.daysOfTheMonthPicker.rawValue) as! DaysOfMonthPickerTableViewCell
			daysOfMonthPicker = cell
			cell.tableView = self
			return cell
		}
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
	
		calculateCells()
		
		switch cells[indexPath.row].cellType {
		case .endDate:
			return dateCellExpanded ? 268 : 156
		case .weekDay:
			return 44 + (tableView.bounds.width - 40) / 7
		case .daysOfTheMonth:
			return 160 + (UIScreen.main.bounds.width - max(0, 6 - 1)*1)/7 * 5
		case .daysOfTheMonthPicker:
			return daysOfMonthPickerExpanded ? 230.0 : 100.0
		default:
			return cells[indexPath.row].height
		}
	}
	
	func calculateCells() {
		cells = []
		switch selectedFrequency {
		case .none:
			cells = []
		case .daily:
			cells = [timeIntervalCell,
					 dateCell]
		case .weekly:
			cells = [timeIntervalCell,
			         dateCell,
			         weekDayCell]
		case .monthly:
			cells = [timeIntervalCell,
			         dateCell,
					 daysOfMonthCell]
		case .yearly:
			cells = [timeIntervalCell,
			         dateCell,
			         daysOfMonthPickerCell,
					 monthsOfYearCell]
		}
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
