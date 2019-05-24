//  AllGroupsCell.swift
//  IvVk
//  Created by Iv on 08/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class AllGroupsCell: UITableViewCell {
    
    @IBOutlet weak var nameAllGroup: UILabel!
    @IBOutlet weak var imageAllGroup: UIImageView!
    
    override func prepareForReuse() {
        nameAllGroup.text = nil
        imageAllGroup.image = nil
    }

}
