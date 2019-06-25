//  GroupData.swift
//  IvVk
//  Created by Iv on 14/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import Alamofire
import RealmSwift
import FirebaseFirestore

var allGroups: [Group] = [] // глобальный список групп

// Класс информации о группе
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
        VkPhotoService.instance.getImage(urlString: photoUrl, completion: completion)
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

// Класс списка групп
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

// Сервис работы с группами
class VkGroupService
{
    static let instance = VkGroupService()
    private init() {}
    static let userGroupsUrl = "https://api.vk.com/method/groups.get"
    static let searchGroupsUrl = "https://api.vk.com/method/groups.search"
    static let groupsCount = 20

    // ---------- manage groups on server
    
    // load user groups
    func loadGroupsList(user: Int, completion: @escaping ([Group]) -> Void ) {
        let pars = Session.instance.getParams(["user_id": String(user), "extended": "1"])
        Alamofire.request(VkGroupService.userGroupsUrl, parameters: pars).responseData(queue: DispatchQueue.global()) { response in
            if response.result.isSuccess {
                if let jsonData = response.result.value,
                   let values = try? JSONDecoder().decode(GroupsList.self, from: jsonData)
                {
                    DispatchQueue.main.async {
                        completion(values.items)
                    }
                }
            } else {
                // todo: handle error
            }
        }
    }
    
    // load groups by searching string
    func searchGroupsList(searchString: String, completion: @escaping ([Group]) -> Void ) {
        let pars = Session.instance.getParams(["q": searchString, "count": String(VkGroupService.groupsCount)])
        Alamofire.request(VkGroupService.searchGroupsUrl, parameters: pars).responseData(queue: DispatchQueue.global()) { response in
            if response.result.isSuccess {
                if let jsonData = response.result.value,
                    let values = try? JSONDecoder().decode(GroupsList.self, from: jsonData)
                {
                    DispatchQueue.main.async {
                        completion(values.items)
                    }
                }
            } else {
                // todo: handle error
            }
        }
    }
    
    // ---------- manage groups in local realm db
    
    /*func loadUserGroupsArrayFromDb() -> [Group] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Group.self))
        } catch {
            print(error)
            return []
        }
    }*/
    
    func loadUserGroupsResultsFromDb() -> Results<Group>? {
        do {
            let realm = try Realm()
            return realm.objects(Group.self)
        } catch {
            print(error)
            return nil
        }
    }
    
    func addUserGroupToDb(_ group: Group) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(group)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func removeUserGroupFromDb(_ group: Group) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(group)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    // ---------- firestore
    
    enum Action: String {
        case add
        case remove
    }
    
    func logUserGroupsInFirebase(_ group: String, _ action: Action) {
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let strDate = formatter.string(from: Date())
        formatter.dateFormat = "yyyyMMddHHmmss"
        let strKey = formatter.string(from: Date())
        db.collection("user_groups_log").document(strKey).setData([
            "userid": Session.instance.userId,
            "group": group,
            "action": action.rawValue,
            "time": strDate
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
}



