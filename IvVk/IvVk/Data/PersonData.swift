//  PersonData.swift
//  IvVk
//  Created by Iv on 14/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import Alamofire

var friends: [Person] = []  // глобальный список друзей текущего пользователя

// Класс информации о пользователе
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
    private var foto: UIImage?  // cached photo
    
    func getFoto(completion: @escaping (UIImage?) -> Void) {
        if foto != nil {
            completion(foto) // photo already loaded and stored in object
            return
        }
        VkPhotoService.instance.getImage(urlString: photoUrl) { [weak self] image in
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

// Класс списка друзей (для маппинга данных запроса friends.get)
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

// Класс списка пользователей (для маппинга данных запроса users.get)
class UsersList : Decodable {
    let response: [Person]
    enum CodingKeys: String, CodingKey {
        case response
    }
}

// Класс сервиса для работы с пользователями
class VkUsersService
{
    static let friendsUrl = "https://api.vk.com/method/friends.get"
    static let usersUrl = "https://api.vk.com/method/users.get"

    // load session user friends list with avatars
    func loadFriendsList(completion: @escaping ([Person]) -> Void ) {
        let pars = Session.instance.getParams(["user_id": String(Session.instance.userId), "fields": "photo_100"])
        Alamofire.request(VkUsersService.friendsUrl, parameters: pars).responseData(queue: DispatchQueue.global()) { response in
            if response.result.isSuccess {
                if let jsonData = response.result.value,
                   let values = try? JSONDecoder().decode(FriendsList.self, from: jsonData)
                {
                        let res = values.items.filter { person in
                            person.firstName?.uppercased() != "DELETED"
                        }
                        DispatchQueue.main.async {
                            completion(res)
                        }
                }
            } else {
                // todo: handle error
            }
        }
    }

    // load user by id
    func loadUser(_ userId: Int, completion: @escaping (Person?) -> Void ) {
        let pars = Session.instance.getParams(["user_ids": String(userId), "fields": "photo_100"])
        Alamofire.request(VkUsersService.usersUrl, parameters: pars).responseData(queue: DispatchQueue.global()) { response in
         var res: Person? = nil
            if response.result.isSuccess {
                if let jsonData = response.result.value,
                    let values = try? JSONDecoder().decode(UsersList.self, from: jsonData),
                    values.response.count > 0
                {
                    res = values.response[0]
                }
            } else {
                // todo: handle error
            }
            DispatchQueue.main.async {
                completion(res)
            }
        }
    }
}

// Класс для получения данных о пользователе по его идентификатору
// Сначала делается попытка получить пользователя из списка друзей
// Затем делается попытка получить пользователя из кэша
// Наконец, делается запрос пользователя на сервере (sic! существует ограничение на количество запросов в секунду)
class UserInfo
{
    static let instance = UserInfo()
    private init() {}
    private var users: [Int: Person] = [:]
    private let syncQueue = DispatchQueue(label: "UsersSyncQueue", attributes: .concurrent)

    func getUserById(userId: Int, completion: @escaping (Person?) -> Void ) {
        var person = getUserFromCache(byId: userId)
        if person == nil {
            person = getUserFromFriendsList(byId: userId)
        }
        if let person = person {
            DispatchQueue.main.async {
                completion(person)
            }
        } else {
            VkUsersService().loadUser(userId) { [weak self] person in
                if let person = person {
                    self?.appendUserToCache(user: person)
                    DispatchQueue.main.async {
                        completion(person)
                    }
                }
            }
        }
    }
    
    private func getUserFromCache(byId id: Int) -> Person? {
        var person: Person?
        syncQueue.sync {
            person = self.users[id]
        }
        return person
    }
    
    private func appendUserToCache(user: Person) {
        syncQueue.async(flags: .barrier) {
            self.users.updateValue(user, forKey: user.id!)
        }
    }
    
    private func getUserFromFriendsList(byId id: Int) -> Person? {
        for person in friends {
            if person.id == id {
                return person
            }
        }
        return nil
    }
}

