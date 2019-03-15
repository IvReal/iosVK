///  FriendsVC.swift
//  Lesson1.1
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

struct Person {
    var name: String
    var foto: UIImage?
    init(_ name: String, _ foto: String) {
        self.name = name
        self.foto = UIImage(named: foto)
    }
}

class FriendsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var friends = [
        Person("Алешечкин Вася", "Алешечкин"),
        Person("Мамолькин Илья", "Мамолькин"),
        Person("Харчочкин Заур", "Харчочкин"),
        Person("Васечкин Алеша", "Васечкин"),
        Person("Лебеда Иван Петрович", "Лебеда"),
        Person("Маша", "photo2"),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
        let friend = friends[indexPath.row]
        cell.nameFriend.text = friend.name
        cell.fotoFriend.image = friend.foto
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let fc = segue.destination as! FriendVC
        if let ind = tableView.indexPathForSelectedRow {
            fc.selectedFriend = friends[ind.row]
        }
    }
    
    // Perform manual segue "showFriend" on select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriend", sender: nil)
    }

}
