///  FriendsVC.swift
//  Lesson1.1
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

struct Section {
    var name: String
    var persons: [Person]
}

class FriendsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var letterControl: LetterControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var groupedFriends: [Section] = []
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(FriendsHeader.self, forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        tableView.register(UINib(nibName: "FriendsHeader", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        groupFriends(friends)
        letterControl.changeLetterHandler = letterChanged
        searchBar.returnKeyType = .done
    }
    
    // letter control change letter handler
    private func letterChanged(_ letter: String) {
        for (index, value) in groupedFriends.enumerated() {
            if value.name == letter {
                tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
            }
        }
    }

    // set friends group array
    private func groupFriends(_ friendList: [Person]) {
        groupedFriends.removeAll()
        var dict = [String: [Person]]()
        for friend in friendList {
            let letter = friend.name.prefix(1).uppercased()
            var p = dict[letter]
            if p == nil {
                p = [Person]()
            }
            p!.append(friend)
            dict[letter] = p
        }
        for letter in dict.keys.sorted() {
            groupedFriends.append(Section(name: letter, persons: dict[letter]!))
        }
        letterControl.Letters = dict.keys.sorted()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedFriends.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedFriends[section].persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
        let friend = groupedFriends[indexPath.section].persons[indexPath.row]
        cell.nameFriend.text = friend.name
        cell.fotoFriend.image = friend.foto
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsHeader") as? FriendsHeader
        //header?.contentView.backgroundColor = .red
        header?.nameSection.text = groupedFriends[section].name
        header?.contentView.backgroundColor = .white
        header?.contentView.alpha = 0.5
        return header
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let fc = segue.destination as! FriendVC
        if let indexPath = tableView.indexPathForSelectedRow {
            fc.selectedFriend = groupedFriends[indexPath.section].persons[indexPath.row]
        }
    }
    
    // Perform manual segue "showFriend" on select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriend", sender: nil)
    }

    // MARK: - Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        if !isSearching {
            //view.endEditing(true)
            groupFriends(friends)
        } else {
            let filteredFriends = friends.filter({ (Person) -> Bool in
                //return Person.name.lowercased().starts(with: searchText.lowercased())
                return Person.name.lowercased().contains(searchText.lowercased())
            })
            groupFriends(filteredFriends)
        }
        tableView.reloadData()
    }

    /* TODO
    // change letter control selected letter while scrolling tableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SetTopLetter()
    }

    private func SetTopLetter() {
        if let array = tableView.indexPathsForVisibleRows {
            var section: Int? = nil
            if array.count > 1 {
                section = array[1].section
            } else if array.count > 0 {
                section = array[0].section
            }
            if let s = section {
                letterControl.selectedLetter = groupedFriends[s].name
            }
        }
    }
    */
}
