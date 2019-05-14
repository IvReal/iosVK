//  MyGroupsVC.swift
//  Lesson1.1
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class MyGroupsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroupsList(user: Session.instance.userId) { list in
            myGroups = list
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        let group = myGroups[indexPath.row]
        cell.nameMyGroup.text = group.name
        group.getFoto { photo in
            cell.imageMyGroup.image = photo
        }
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
            myGroups.remove(at: indexPath.row)
            tableView.reloadData()
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
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
                let group = allGroups[indexPath.row]
                // add group to target
                if !myGroups.contains(group) {
                    myGroups.append(group)
                }
                // refresh table
                tableView.reloadData()
            }
        }
    }
}
