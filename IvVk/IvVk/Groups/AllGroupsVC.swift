//  AllGroupsVC.swift
//  IvVk
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class AllGroupsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VkGroupService.instance.searchGroupsList(searchString: "travel") { list in
            allGroups = list
            self.tableView.reloadData()
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
}
