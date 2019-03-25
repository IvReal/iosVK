//  FriendsCell.swift
//  Lesson1.1
//  Created by Iv on 08/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet weak var nameFriend: UILabel!
    @IBOutlet weak var fotoFriend: RoundImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
