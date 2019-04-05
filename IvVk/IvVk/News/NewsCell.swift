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
    
    private weak var currentNews: News? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // likecontrol handler
        countLikes.tryChangeLike = likesChanged
        // image tap recognizer
        imageNews.isUserInteractionEnabled = true
        imageNews.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    
    func setCurrentNews(_ news: News?) {
        currentNews = news
        if let n = currentNews {
            labelAuthor.text = n.author
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            labelDate.text = dateFormatter.string(from: n.date)
            textNews.text = n.text
            imageNews.image = n.image
            countLikes.setLikeStatus(n.countLike, n.isCurrentUserLiked)
        }
    }
    
    override func prepareForReuse() {
        labelAuthor.text = nil
        labelDate.text = nil
        textNews.text = nil
        imageNews.image = nil
        countLikes.setLikeStatus(0, false)
    }
    
    // likes tap handler
    private func likesChanged() -> (Int, Bool?) {
        var res: (Int, Bool?) = (0, nil)
        if let n = currentNews {
            res.1 = n.changeLike()
            res.0 = n.countLike
        }
        return res
    }

    // image tap handler
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

    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    */
}
