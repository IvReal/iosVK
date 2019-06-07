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
    
    private weak var currentNews: NewsItem? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // likecontrol handler
        countLikes.tryChangeLike = likesChanged
        // image tap recognizer
        imageNews.isUserInteractionEnabled = true
        imageNews.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    
    func setCurrentNews(_ news: NewsItem?) {
        currentNews = news
        guard let cnew = currentNews else { return }
        textNews.text = cnew.text
        labelDate.text = getDateStringFromUnixTime(time: cnew.date)
        labelAuthor.text = nil // TODO
        if cnew.type == "photo" {
            if let photo = cnew.photo {
                cnew.photo?.getFoto() { image in
                    self.imageNews.image = image
                }
                textNews.text = photo.text
                countLikes.setLikeStatus(photo.likes?.count ?? 0, (photo.likes?.user_likes ?? 0) == 1)
            }
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
        if let likes = currentNews?.photo?.likes {
            res.1 = likes.user_likes == 0 // like or unlike
            likes.count = (likes.count ?? 0) + 1  * (likes.user_likes == 0 ? 1 : -1) // new like count in object
            likes.user_likes = likes.user_likes == 0 ? 1 : 0 // is current user liked
            res.0 = likes.count ?? 0 // new like count in control
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
}
