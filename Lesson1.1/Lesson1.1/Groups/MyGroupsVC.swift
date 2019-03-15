//  MyGroupsVC.swift
//  Lesson1.1
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class MyGroupsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var groups = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        let group = groups[indexPath.row]
        cell.nameMyGroup.text = group
        return cell
    }
    
    // Support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "AddGroup" {
            // source controller
            let allGroupsController = segue.source as! AllGroupsVC
            // cell index
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                // group by index
                let group = allGroupsController.groups[indexPath.row]
                // add group to target
                if !groups.contains(group) {
                    groups.append(group)
                }
                // refresh table
                tableView.reloadData()
            }
        }
    }
}
