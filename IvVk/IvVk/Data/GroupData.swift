//  GroupData.swift
//  IvVk
//  Created by Iv on 14/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import Alamofire
import RealmSwift

var myGroups: [Group] = []
var allGroups: [Group] = []

class Group : Object, Decodable {
    
    @objc dynamic var id: Int
    @objc dynamic var name: String?
    @objc dynamic var photoUrl: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photoUrl = "photo_100" //"photo_50", photo_200
    }
    
    func getFoto(completion: @escaping (UIImage?) -> Void ) {
        getImage(urlString: photoUrl, completion: completion)
    }
    
    /* standard Equatable
     static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
     } */
    override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? Group {
            return obj.id == self.id
        }
        return false
    }
}

class GroupsList : Decodable {
    let count: Int
    let items: [Group]
    enum CodingKeys: String, CodingKey {
        case count
        case items
    }
    enum ResponseKeys: String, CodingKey {
        case response
    }
    required init(from decoder: Decoder) throws {
        let responseContainer = try decoder.container(keyedBy: ResponseKeys.self)
        let itemsContainer = try responseContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.count = try itemsContainer.decode(Int.self, forKey: .count)
        self.items = try itemsContainer.decode([Group].self, forKey: .items)
    }
}

// ---------- manage groups on server

// load user groups
func loadGroupsList(user: Int, completion: @escaping ([Group]) -> Void ) {
    let pars = Session.instance.getParams(["user_id": String(user), "extended": "1"])
    Alamofire.request("https://api.vk.com/method/groups.get", parameters: pars).responseData { repsonse in
        guard let data = repsonse.value else { return }
        let list = try? JSONDecoder().decode(GroupsList.self, from: data)
        if let glist = list {
            completion(glist.items)
        }
    }
}

// load groups by searching string
func searchGroupsList(searchString: String, completion: @escaping ([Group]) -> Void ) {
    let pars = Session.instance.getParams(["q": searchString, "count": "15"])
    Alamofire.request("https://api.vk.com/method/groups.search", parameters: pars).responseData { repsonse in
        guard let data = repsonse.value else { return }
        let list = try? JSONDecoder().decode(GroupsList.self, from: data)
        if let glist = list {
            completion(glist.items)
        }
    }
}

// ---------- manage groups in db

func loadUserGroupsFromDb() {
    do {
        let realm = try Realm()
        myGroups = Array(realm.objects(Group.self))
    } catch {
        print(error)
    }
}

func addUserGroupToDb(_ group: Group) -> Bool {
    do {
        let realm = try Realm()
        realm.beginWrite()
        realm.add(group)
        try realm.commitWrite()
        return true
    } catch {
        print(error)
        return false
    }
}

func removeUserGroupFromDb(_ group: Group) -> Bool {
    do {
        let realm = try Realm()
        realm.beginWrite()
        realm.delete(group)
        try realm.commitWrite()
        return true
    } catch {
        print(error)
        return false
    }
}



