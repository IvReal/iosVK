//  GroupData.swift
//  IvVk
//  Created by Iv on 14/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import Alamofire

var myGroups: [Group] = []
var allGroups: [Group] = []

class Group : Decodable, Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int?
    var name: String?
    var photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photoUrl = "photo_100" //"photo_50", photo_200
    }
    
    func getFoto(completion: @escaping (UIImage?) -> Void ) {
        if let urlString = photoUrl,
           let url = URL(string: urlString)
        {
            if let cachedImage = loadImageFromFile(url) {
                completion(cachedImage)  // photo has cached in file
            } else {
                DispatchQueue.main.async {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data)
                    {
                        saveImageToFile(image, url)  // cache image to file
                        completion(image)  // photo loaded from server
                    }
                }
            }
        }
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

