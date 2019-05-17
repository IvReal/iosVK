//
//  AllGroupsCell.swift
//  Lesson1.1
//
//  Created by Iv on 08/03/2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {
    
    @IBOutlet weak var nameAllGroup: UILabel!
    @IBOutlet weak var imageAllGroup: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        nameAllGroup.text = nil
        imageAllGroup.image = nil
    }

}
