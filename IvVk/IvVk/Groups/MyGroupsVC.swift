//  MyGroupsVC.swift
//  Lesson1.1
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class MyGroupsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load from server
        /* loadGroupsList(user: Session.instance.userId) { list in
            myGroups = list
            self.tableView.reloadData()
        } */
        
        // load from db
        loadUserGroupsFromDb()
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
            // Delete the row from the data source
            if removeUserGroupFromDb(myGroups[indexPath.row]) {
                myGroups.remove(at: indexPath.row)
                tableView.reloadData()
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "AddGroup",
            let allGroupsController = segue.source as? AllGroupsVC, // source controller
            let indexPath = allGroupsController.tableView.indexPathForSelectedRow // cell index
        else { return }
        let group = allGroups[indexPath.row] // group by index
        // add group to target
        if !myGroups.contains(group) {
            if addUserGroupToDb(group) { // save to db
                myGroups.append(group)   // add to array
                tableView.reloadData()   // refresh table
            }
        }
    }
}
