//  FriendsCell.swift
//  Lesson1.1
//  Created by Iv on 08/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet weak var nameFriend: UILabel!
    @IBOutlet weak var fotoFriend: RoundImageView!
    
    override func prepareForReuse() {
        nameFriend.text = nil
        fotoFriend.image = nil
    }
    
    func loadCell(friend: Person) {
        nameFriend.text = friend.name
        friend.getFoto { [weak self] image in
            self?.fotoFriend.image = image
        }
    }

}
