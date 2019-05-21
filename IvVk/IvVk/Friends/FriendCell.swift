//  FriendCell.swift
//  Lesson1.1
//  Created by Iv on 08/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class FriendCell: UICollectionViewCell {
    
    @IBOutlet weak var fotoFriend: UIImageView!
    
    override func prepareForReuse() {
        fotoFriend.image = nil
    }
    
    func loadCell(photo: Photo) {
        photo.getFoto { [weak self] image in
            self?.fotoFriend.image = image
        }
    }
}
