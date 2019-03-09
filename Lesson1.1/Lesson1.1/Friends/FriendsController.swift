//  FriendsController.swift
//  Lesson1.1
//  Created by Iv on 08/03/2019.
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

class FriendsController: UITableViewController {

    var friends = [
        Person("Алешечкин Вася", "Алешечкин"),
        Person("Мамолькин Илья", "Мамолькин"),
        Person("Харчочкин Заур", "Харчочкин"),
        Person("Васечкин Алеша", "Васечкин"),
        Person("Лебеда Иван Петрович", "Лебеда"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsCell
        let friend = friends[indexPath.row]
        cell.nameFriend.text = friend.name
        cell.fotoFriend.image = friend.foto
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
    */
 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let fc = segue.destination as! FriendController
        if let ind = tableView.indexPathForSelectedRow {
            fc.selectedFriend = friends[ind.row]
        }
    }
    
    // Perform manual segue "showFriend" on select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriend", sender: nil)
    }
}
