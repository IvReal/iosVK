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
        cell.setCurrentNews(news[indexPath.row])
        return cell
    }
    
    // MARK: -  Animation of cells appearance
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let newscell = cell as? NewsCell {
            UIView.animate(withDuration: 1.5) {
                newscell.contentView.alpha = 1
                newscell.contentView.transform = CGAffineTransform.identity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let newscell = cell as? NewsCell {
            newscell.contentView.alpha = 0
            newscell.contentView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        }
    }
}
