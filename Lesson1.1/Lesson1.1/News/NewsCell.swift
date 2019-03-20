//  NewsCell.swift
//  Lesson1.1
//  Created by Iv on 18/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textNews: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var countLikes: LikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countLikes.changeLikeHandler = likesChanged
    }
    
    private func likesChanged(_ count: Int, _ plus: Bool) {
        //print("You \(plus ? "+" : "-") like, now \(count) likes")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
