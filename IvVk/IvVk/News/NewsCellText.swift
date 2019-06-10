//  NewsCellText.swift
//  Created by Iv on 07/06/2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import UIKit

class NewsCellText: UITableViewCell {

    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textNews: UILabel!
    @IBOutlet weak var countLikes: LikeControl!
    
    private weak var currentNews: PostNews? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCurrentNews(_ news: PostNews?) {
        currentNews = news
        guard let cnew = currentNews else { return }
        textNews.text = cnew.text
        labelDate.text = getDateStringFromUnixTime(time: cnew.date)
        labelAuthor.text = nil // TODO
        if cnew.type == "post" {
        }
    }
}
