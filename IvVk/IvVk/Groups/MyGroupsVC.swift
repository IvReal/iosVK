//  MyGroupsVC.swift
//  IvVk
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import RealmSwift

class MyGroupsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
 
    //var myGroups: [Group]
    //var myDbGroups: [Group]
    var myDbGroups: Results<Group>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* load from server
        loadGroupsList(user: Session.instance.userId) { list in
            myGroups = list
            self.tableView.reloadData()
        } */
        
        /* load from db
        myDbGroups = loadUserGroupsArrayFromDb() */
        
        /* load from db with realm notifications support */
        myDbGroups = loadUserGroupsResultsFromDb()
        token = myDbGroups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDbGroups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        if let group = myDbGroups?[indexPath.row] {
            cell.nameMyGroup.text = group.name
            group.getFoto { [weak cell] photo in
                cell?.imageMyGroup.image = photo
            }
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
            if let group = myDbGroups?[indexPath.row] {
                removeUserGroupFromDb(group) // remove from db
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "AddGroup",
            let allGroupsController = segue.source as? AllGroupsVC, // source controller
            let indexPath = allGroupsController.tableView.indexPathForSelectedRow, // cell index
            let groups = myDbGroups
        else { return }
        let group = allGroups[indexPath.row] // group by index
        // add group to target if it is not exists
        if !groups.contains(group) {
            addUserGroupToDb(group) // save to db
        }
    }
}
