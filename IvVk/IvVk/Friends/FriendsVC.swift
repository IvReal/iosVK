//  FriendsVC.swift
//  IvVk
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.myLightGreen

        tableView.register(UINib(nibName: "FriendsHeader", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        letterControl.changeLetterHandler = letterChanged
        searchBar.returnKeyType = .done
        tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
        
        refresh()
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
        cell.loadCell(friend: friend)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsHeader") as? FriendsHeader
        header?.nameSection.text = groupedFriends[section].name
        header?.contentView.backgroundColor = .white
        header?.contentView.alpha = 0.5
        return header
    }
    
    private func refresh() {
        /*VkUsersService().loadFriendsList { [weak self] list in
            friends = list
            self?.groupFriends(friends)
            self?.tableView.reloadData()
        }*/
        let userServiceProxy = VkUsersServiceProxy(userService: VkUsersService())
        userServiceProxy.loadFriendsList { [weak self] list in
            friends = list
            self?.groupFriends(friends)
            self?.tableView.reloadData()
        }
    }

    @IBAction func refreshFriends(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fc = segue.destination as? FriendVC {
            if let indexPath = tableView.indexPathForSelectedRow {
                let p = groupedFriends[indexPath.section].persons[indexPath.row]
                fc.loadUserPhotos(userId: p.id ?? 0, userName: p.firstName)
            }
        }
    }
    
    // Perform manual segue "showFriend" on select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriend", sender: nil)
    }

    // MARK: - Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            clearSearching()
        } else {
            let filteredFriends = friends.filter({ (Person) -> Bool in
                //return Person.name.lowercased().starts(with: searchText.lowercased())
                return Person.name.lowercased().contains(searchText.lowercased())
            })
            groupFriends(filteredFriends)
            tableView.reloadData()
        }
    }
    
    private func clearSearching(endEditing end: Bool = false) {
        searchBar.text = nil
        groupFriends(friends)
        tableView.reloadData()
        if end {
            view.endEditing(true)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearching(endEditing: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearSearching(endEditing: true)
    }
}
