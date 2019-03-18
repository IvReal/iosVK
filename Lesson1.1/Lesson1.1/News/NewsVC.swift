//
//  NewsVC.swift
//  Lesson1.1
//
//  Created by Iv on 18/03/2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import UIKit

class NewsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let n = news[indexPath.row]
        cell.labelAuthor.text = n.author
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.labelDate.text = dateFormatter.string(from: n.date)
        cell.textNews.text = n.text
        cell.imageNews.image = n.image
        cell.countLikes.countLike = n.countLike
        return cell
    }
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        //return cell.countLikes.frame.origin.y + cell.countLikes.frame.height + 5.0
    //}
    
}
