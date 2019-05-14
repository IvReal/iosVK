//  RealData.swift
//  IvVk
//  Created by Iv on 26/04/2019.
//  Copyright © 2019 Iv. All rights reserved.

import Foundation
import UIKit
import Alamofire

//------------- Session

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

//------------- Friends

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
        if let urlString = photoUrl,
           let url = URL(string: urlString)
        {
            if let cachedImage = loadImageFromFile(url) {
                self.foto = cachedImage
                completion(cachedImage)  // photo has cached in file
            } else {
                DispatchQueue.main.async {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data)
                    {
                        self.foto = image
                        saveImageToFile(image, url)  // cache image to file
                        completion(image)  // photo loaded from server
                    }
                }
            }
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

//------------- Photos

var userPhotos: [Photo] = []

class Photo : Decodable {
    var id: Int?
    var text: String?
    var date: Date?
    var likes: Likes?
    var sizes: [PhotoCopy]

    static let allowCache = true

    var photoUrl: PhotoCopy? {
        let list = sizes.sorted(by: { $0.sortOrder < $1.sortOrder })
        return list.count > 0 ? list[0] : nil
    }
    
    func getFoto(completion: @escaping (UIImage?) -> Void ) {
        if let urlObject = photoUrl,
           let urlString = urlObject.url,
           let url = URL(string: urlString)
        {
            if Photo.allowCache, let cachedImage = loadImageFromFile(url) {
                completion(cachedImage)  // cache allowed and photo has cached in file
            } else {
                DispatchQueue.main.async {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data)
                    {
                        if Photo.allowCache { saveImageToFile(image, url) }  // cache image to file
                        completion(image)  // photo loaded from server
                    }
                }
            }
        }
    }
}

class PhotoCopy : Decodable {
    var type: String?
    var url: String?
    var width: Int?
    var height: Int?
    var sortOrder: Int {
        switch type {
        case "s": return 7 // пропорциональная копия изображения с максимальной стороной 75px;
        case "m": return 6 // пропорциональная копия изображения с максимальной стороной 130px;
        case "x": return 2 // пропорциональная копия изображения с максимальной стороной 604px;
        case "o": return 5 // если соотношение "ширина/высота" исходного изображения меньше или равно 3:2, то пропорциональная копия с максимальной стороной 130px. Если соотношение "ширина/высота" больше 3:2, то копия обрезанного слева изображения с максимальной стороной 130px и соотношением сторон 3:2.
        case "p": return 4 // если соотношение "ширина/высота" исходного изображения меньше или равно 3:2, то пропорциональная копия с максимальной стороной 200px. Если соотношение "ширина/высота" больше 3:2, то копия обрезанного слева и справа изображения с максимальной стороной 200px и соотношением сторон 3:2.
        case "q": return 3 // если соотношение "ширина/высота" исходного изображения меньше или равно 3:2, то пропорциональная копия с максимальной стороной 320px. Если соотношение "ширина/высота" больше 3:2, то копия обрезанного слева и справа изображения с максимальной стороной 320px и соотношением сторон 3:2.
        case "r": return 1 // если соотношение "ширина/высота" исходного изображения меньше или равно 3:2, то пропорциональная копия с максимальной стороной 510px. Если соотношение "ширина/высота" больше 3:2, то копия обрезанного слева и справа изображения с максимальной стороной 510px и соотношением сторон 3:2
        case "y": return 8 // пропорциональная копия изображения с максимальной стороной 807px;
        case "z": return 9 // пропорциональная копия изображения с максимальным размером 1080x1024;
        case "w": return 10 // пропорциональная копия изображения с максимальным размером 2560x2048px.
        default: return 100
        }
    }
}

class Likes : Decodable {
    var count: Int?
    var user_likes: Bool?

    enum CodingKeys: String, CodingKey {
        case count
        case user_likes
    }
}

class PhotosList : Decodable {
    let count: Int
    let items: [Photo]
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
        self.items = try itemsContainer.decode([Photo].self, forKey: .items)
    }
}

// load user photos
func loadPhotosList(owner: Int, completion: @escaping ([Photo]) -> Void ) {
    let pars = Session.instance.getParams(["owner_id": String(owner), "count": "10"])
    Alamofire.request("https://api.vk.com/method/photos.getAll", parameters: pars).responseData { repsonse in
        var res: [Photo] = []
        if let data = repsonse.value {
            let list = try? JSONDecoder().decode(PhotosList.self, from: data)
            if let plist = list {
                res = plist.items
            }
        }
        completion(res)
    }
}

//------------- Groups

var myGroups: [Group] = []
var allGroups: [Group] = []

class Group : Decodable {
    var id: Int?
    var name: String?
    var photo: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo = "photo_100" //"photo_50", photo_200
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
    let pars = Session.instance.getParams(["q": searchString, "count": "10"])
    Alamofire.request("https://api.vk.com/method/groups.search", parameters: pars).responseData { repsonse in
        guard let data = repsonse.value else { return }
        let list = try? JSONDecoder().decode(GroupsList.self, from: data)
        if let glist = list {
            completion(glist.items)
        }
    }
}

//------------- Save/Load image files

func getCacheDir() -> URL? {
    return try? FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
}

func saveImageToFile(_ image: UIImage, _ imageUrl: URL) {
    let dir = getCacheDir()
    guard let directory = dir else { return }
    let path = directory.appendingPathComponent(String(imageUrl.hashValue))
    let data = image.jpegData(compressionQuality: 0.5)
    guard let imgdata = data else { return }
    do {
        try imgdata.write(to: path)
        //print("File saved successfully")
    } catch {
        print("Error occured while file saving: \(error)")
    }
}

func loadImageFromFile(_ imageUrl: URL) -> UIImage? {
    let dir = getCacheDir()
    guard let directory = dir else { return nil }
    let path = directory.appendingPathComponent(String(imageUrl.hashValue))
    if !FileManager.default.fileExists(atPath: path.path) { return nil }
    do {
        let imageData = try Data(contentsOf: path)
        //print("File loaded successfully")
        return UIImage(data: imageData)
    } catch {
        print("Error occured while file loading: \(error)")
        return nil
    }
}

func clearCache() {
    let dir = getCacheDir()
    guard let directory = dir else { return }
    do {
        var filePaths = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
        filePaths = filePaths.filter { !$0.hasDirectoryPath }
        for filePath in filePaths {
            try FileManager.default.removeItem(atPath: filePath.path)
        }
    } catch {
        print("Could not clear folder: \(error)")
    }
}
