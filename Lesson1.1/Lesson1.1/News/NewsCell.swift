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
        // likecontrol handler
        countLikes.changeLikeHandler = likesChanged
        // image tap recognizer
        imageNews.isUserInteractionEnabled = true
        imageNews.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    
    override func prepareForReuse() {
        labelAuthor.text = nil
        labelDate.text = nil
        textNews.text = nil
        imageNews.image = nil
        countLikes.countLike = 0
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        // first decrease scale
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:
        {
            self.imageNews.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: { _ in
            // next revert scale with spring effect
            UIView.animate(withDuration: 2, delay: 0,
                           usingSpringWithDamping: 0.25, initialSpringVelocity: 0,
                           options: [], animations:
            {
                self.imageNews.transform = .identity
            })
        })
    }
    
    private func likesChanged(_ count: Int, _ plus: Bool) {
        //print("You \(plus ? "+" : "-") like, now \(count) likes")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
