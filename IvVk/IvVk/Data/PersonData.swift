//  PersonData.swift
//  IvVk
//  Created by Iv on 14/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import Alamofire

var friends: [Person] = []
var user: Person!

class Person : Decodable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photoUrl = "photo_100" //"photo_200_orig"
    }
    
    var name: String { return "\(lastName ?? "") \(firstName ?? "")" } // full name
    var foto: UIImage?  // cached photo // todo: make private
    
    func getFoto(completion: @escaping (UIImage?) -> Void ) {
        if foto != nil {
            completion(foto) // photo already loaded and stored in object
            return
        }
        getImage(urlString: photoUrl) { [weak self] image in
            self?.foto = image
            completion(image)
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(Int.self, forKey: .id)
        self.firstName = try? container.decode(String.self, forKey: .firstName)
        self.lastName = try? container.decode(String.self, forKey: .lastName)
        self.photoUrl = try? container.decode(String.self, forKey: .photoUrl)
    }
}

class FriendsList : Decodable {
    let count: Int
    let items: [Person]
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
        self.items = try itemsContainer.decode([Person].self, forKey: .items)
    }
}

class UsersList : Decodable {
    let response: [Person]
    enum CodingKeys: String, CodingKey {
        case response
    }
}

// load session user friends list with avatars
func loadFriendsList(completion: @escaping ([Person]) -> Void ) {
    let pars = Session.instance.getParams(["user_id": String(Session.instance.userId), "fields": "photo_100"])
    Alamofire.request("https://api.vk.com/method/friends.get", parameters: pars).responseData { repsonse in
        guard let data = repsonse.value else { return }
        let list = try? JSONDecoder().decode(FriendsList.self, from: data)
        if let flist = list {
            let res = flist.items.filter { person in
                person.firstName?.uppercased() != "DELETED"
            }
            completion(res)
        }
    }
    /* don't work :-(
     Alamofire("https://api.vk.com/method/friends.get", parameters: pars).responseArray(keyPath: "items") { (response: DataResponse<[PersonVk]>) in
     let friends = response.result.value
     }
     */
}

// load current user
func loadCurrentUser(completion: @escaping (Person?) -> Void ) {
    let pars = Session.instance.getParams(["user_ids": String(Session.instance.userId), "fields": "photo_100"])
    Alamofire.request("https://api.vk.com/method/users.get", parameters: pars).responseData { repsonse in
        var res: Person? = nil
        if let data = repsonse.value {
            let list = try? JSONDecoder().decode(UsersList.self, from: data)
            if let ulist = list, ulist.response.count > 0 {
                res = ulist.response[0]
            }
        }
        completion(res)
    }
}

