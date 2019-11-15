//  AllGroupsVC.swift
//  IvVk
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class AllGroupsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.myLightGreen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if allGroups.count == 0 {
            refresh()
        }
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell
        let group = allGroups[indexPath.row]
        cell.nameAllGroup.text = group.name
        group.getFoto { photo in
            cell.imageAllGroup.image = photo
        }
        return cell
    }
    
    private func refresh() {
        var userIdTextField: UITextField?
        // Declare alert message
        let dialogMessage = UIAlertController(title: "Groups searching", message: "Please enter groups search string", preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if let userInput = userIdTextField!.text {
                VkGroupService.instance.searchGroupsList(searchString: userInput) { [weak self] list in
                    allGroups = list
                    self?.tableView.reloadData()
                }
           }
        })
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        // Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        // Add input TextField to dialog message
        dialogMessage.addTextField { (textField) -> Void in
            userIdTextField = textField
            userIdTextField?.placeholder = "search string"
        }
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func refreshGroups(_ sender: UIBarButtonItem) {
        refresh()
    }
}
