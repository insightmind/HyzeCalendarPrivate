//
//  SettingsListGroupTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 26.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

enum SettingsListGroupTableViewCellType {
    case onOffButton
    case button
    case none
}

struct SettingsListGroupCellInformations {
    let type: SettingsListGroupTableViewCellType
    let title: String
    let color: UIColor = Color.blue
    let textColor: UIColor = Color.white
    let buttonColor: UIColor = Color.red
    let key: String
}

struct SettingsListGroupCellConfigurations {
    static let darkMode = SettingsListGroupCellInformations(type: .onOffButton, title: "DarkMode", key: "DarkMode")
    static let showWeekSeperators = SettingsListGroupCellInformations(type: .onOffButton, title: "show Week seperators", key: "showLinesInCalendarView")
    static let animateDayView = SettingsListGroupCellInformations(type: .onOffButton, title: "allow Animations", key: "animateDayView")
    static let isAMPM = SettingsListGroupCellInformations(type: .onOffButton, title: "24 hours", key: "IsAMPM")
    static let showWeekNumber = SettingsListGroupCellInformations(type: .onOffButton, title: "show Weeknumbers", key: "showWeekNumber")
}

class SettingsListGroupTableViewController: UITableViewController {
    
    let reuse: String = "onOffCell"
    
//    private var data: [SettingsListGroupCellInformations]? {
//        didSet {
//            self.tableView.reloadData()
//        }
//    }
//
//    func fetchData(_ data: [SettingsListGroupCellInformations]) {
//        self.data = data
//    }
    
    let data = [SettingsListGroupCellConfigurations.darkMode,
                SettingsListGroupCellConfigurations.showWeekSeperators,
                SettingsListGroupCellConfigurations.animateDayView,
                SettingsListGroupCellConfigurations.isAMPM,
                SettingsListGroupCellConfigurations.showWeekNumber]

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "SettingsListGroupOnOffButtonTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: reuse)
        self.tableView.allowsSelection = false
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
//        if let secureData = data {
//            return secureData.count
//        } else {
//            return 0
//        }
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse, for: indexPath) as! SettingsListGroupOnOffButtonTableViewCell
        
        cell.fetchConfiguration(data[indexPath.item])

        // Configure the cell...

        return cell
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
