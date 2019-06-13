//  NewsVC.swift
//  IvVk
//  Created by Iv on 18/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

var lastnews: [NewsItem] = []

class NewsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ns = VkNewsService()
        ns.getNews() { list in
            lastnews = list
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastnews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsitem = lastnews[indexPath.row]
        if let nphoto = newsitem as? PhotoNews {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            cell.setCurrentNews(nphoto)
            return cell
        }
        else if let npost = newsitem as? PostNews {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellText", for: indexPath) as! NewsCellText
            cell.setCurrentNews(npost)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellText", for: indexPath) as! NewsCellText
            cell.setCurrentNews(nil)
            return cell
        }
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
