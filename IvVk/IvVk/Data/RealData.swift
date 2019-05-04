//  RealData.swift
//  IvVk
//  Created by Iv on 26/04/2019.
//  Copyright © 2019 Iv. All rights reserved.

import Foundation
import UIKit
import Alamofire

class Session {
    static let instance = Session()
    static let vkAPI = "5.95"
    static let vkClientId = "6964606"

    private init() {}
    
    public func clear() {
        fio = ""
        token = ""
        userId = 0
    }
    
    public func getParams(_ params: [String: String]) -> Parameters {
        // common params
        var res: Parameters = [
            "access_token": token, //Session.instance.token,
            "v": Session.vkAPI,
        ]
        // specific params
        for (key, val) in params {
            res[key] = val;
        }
        return res
    }

    var login: String? { return userId > 0 ? String(userId) : nil  }
    var fio: String = ""
    var token: String = ""
    var userId: Int = 0
}

class Person : Decodable {
    var id: Int?
    var first_name: String?
    var last_name: String?
    var photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case first_name
        case last_name
        case photoUrl = "photo_100" //"photo_200_orig" 
    }

    var name: String { return "\(last_name ?? "") \(first_name ?? "")" } // full name
    var foto: UIImage?  // cached photo // todo: make private

    func getFoto(completion: @escaping (UIImage?) -> Void ) {
        if foto != nil {
            completion(foto)
            return
        }
        if let urlString = photoUrl,
           let url = URL(string: urlString)
        {
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data)
                {
                    self.foto = image
                    completion(image)
                }
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(Int.self, forKey: .id)
        self.first_name = try? container.decode(String.self, forKey: .first_name)
        self.last_name = try? container.decode(String.self, forKey: .last_name)
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

var friends: [Person] = []

/*
 // photos
 pars = session.getParams(["owner_id": String(Session.instance.userId), "count": "2"])
 sessionManager.request("https://api.vk.com/method/photos.getAll", parameters: pars).responseJSON { response in
 print(response.value ?? "")
 }
 // user groups
 pars = session.getParams(["user_id": String(Session.instance.userId), "extended": "1"])
 sessionManager.request("https://api.vk.com/method/groups.get", parameters: pars).responseJSON { response in
 print(response.value ?? "")
 }
 // search groups
 pars = session.getParams(["q": "Travel", "count": "10"])
 sessionManager.request("https://api.vk.com/method/groups.search", parameters: pars).responseJSON { response in
 print(response.value ?? "")
 }
*/
