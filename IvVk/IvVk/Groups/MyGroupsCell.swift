//  MyGroupsCell.swift
//  IvVk
//  Created by Iv on 08/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class MyGroupsCell: UITableViewCell {

    @IBOutlet weak var nameMyGroup: UILabel!
    @IBOutlet weak var imageMyGroup: UIImageView!
    
    override func prepareForReuse() {
        nameMyGroup.text = nil
        imageMyGroup.image = nil
    }

}
