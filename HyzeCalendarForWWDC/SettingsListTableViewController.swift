//
//  SettingsListTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 25.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

struct SettingsListTableViewCellConfiguration {
    let title: String
//    let viewController: UIViewController
    let height: CGFloat
}

class SettingsListTableViewController: UITableViewController {

    let reuseIdentifier = "settingsBasicCell"
    
    let data = [SettingsListTableViewCellConfiguration(title: "General", height: 300 + 28 + 16),
                SettingsListTableViewCellConfiguration(title: "Creator", height: 28 + 16 + 60),
                SettingsListTableViewCellConfiguration(title: "Design", height: 125),
                SettingsListTableViewCellConfiguration(title: "Support", height: 175)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 50, right: 0)
        let nib = UINib(nibName: "SettingsListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        //Uncomment the following line to preserve selection between presentations
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
        //return data.count
        return 2
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsListTableViewCell

        cell.setTitle(data[indexPath.row].title)
        cell.connect(to: self)
        
        if indexPath.row == 0 {
            let tView = SettingsListGroupTableViewController(style: .plain)
            let _ = cell.setMainView(to: tView)
        } else if indexPath.row == 1 {
            let cellView = SettingsLinkViewController()
            let _ = cell.setMainView(to: cellView)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[indexPath.row].height
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
