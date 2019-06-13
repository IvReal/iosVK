//  NewsCellText.swift
//  IvVk
//  Created by Iv on 07/06/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class NewsCellText: UITableViewCell {

    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var countLikes: LikeControl!
    @IBOutlet weak var imageAvatar: RoundImageView!
    @IBOutlet weak var textNews: UILabel!
    
    private weak var currentNews: PostNews? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // likecontrol handler
        countLikes.tryChangeLike = likesChanged
    }
    
    func setCurrentNews(_ news: PostNews?) {
        currentNews = news
        guard let newsitem = currentNews else { return }
        if let userid = newsitem.source_id, userid > 0 {
            UserInfo.instance.getUserById(userId: userid) { [weak self] user in
                if let user = user {
                    self?.labelAuthor.text = user.name
                    user.getFoto { [weak self] photo in
                        self?.imageAvatar.image = photo
                    }
                }
            }
        }
        labelDate.text = getDateStringFromUnixTime(time: newsitem.date)
        textNews.text = newsitem.text
        countLikes.setLikeStatus(newsitem.likes?.count ?? 0, (newsitem.likes?.user_likes ?? 0) == 1)
    }
    
    override func prepareForReuse() {
        labelAuthor.text = nil
        labelDate.text = nil
        textNews.text = nil
        imageAvatar.image = nil
        countLikes.setLikeStatus(0, false)
    }
    
    // likes tap handler
    private func likesChanged() -> (Int, Bool?) {
        var res: (Int, Bool?) = (0, nil)
        if let likes = currentNews?.likes {
            res.1 = likes.user_likes == 0 // like or unlike
            likes.count = (likes.count ?? 0) + 1  * (likes.user_likes == 0 ? 1 : -1) // new like count in object
            likes.user_likes = likes.user_likes == 0 ? 1 : 0 // is current user liked
            res.0 = likes.count ?? 0 // new like count in control
        }
        return res
    }
}
