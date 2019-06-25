//  PhotoData.swift
//  IvVk
//  Created by Iv on 14/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import Alamofire

var userPhotos: [Photo] = []  // список фотографий выбранного друга

// Класс информации о фото
class Photo : Decodable {
    var id: Int?
    var text: String?
    var date: Double?
    var likes: Likes?
    var sizes: [PhotoCopy]
    
    var photoUrl: PhotoCopy? {
        let list = sizes.sorted(by: { $0.sortOrder < $1.sortOrder })
        return list.count > 0 ? list[0] : nil
    }
    
    func getFoto(completion: @escaping (UIImage?) -> Void ) {
        if let urlObject = photoUrl {
            VkPhotoService.instance.getImage(urlString: urlObject.url, completion: completion)
        }
    }
}

// Класс копии фото
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

// Класс информации о лайке
class Likes : Decodable {
    var count: Int?
    var user_likes: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case user_likes
    }
}

// Класс списка фото
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

// Сервис получения фото
class VkPhotoService
{
    static let instance = VkPhotoService()
    private init() {}
    static let allPhotoUrl = "https://api.vk.com/method/photos.getAll"
    static let photosCount = 20
    
    // load user photos
    func loadPhotosList(owner: Int, completion: @escaping ([Photo]) -> Void ) {
        let pars = Session.instance.getParams(["owner_id": String(owner), "count": String(VkPhotoService.photosCount)])
        Alamofire.request(VkPhotoService.allPhotoUrl, parameters: pars).responseData(queue: DispatchQueue.global()) { response in
            var res: [Photo] = []
            if response.result.isSuccess {
                if let jsonData = response.result.value,
                   let values = try? JSONDecoder().decode(PhotosList.self, from: jsonData)
                {
                    res = values.items
                }
            } else {
                // todo: handle error
            }
            DispatchQueue.main.async {
                completion(res)
            }
        }
    }

    // get image by url with caching support
    func getImage(urlString: String?, completion: @escaping (UIImage?) -> Void ) {
        if let urlStr = urlString, let url = URL(string: urlStr) {
            if !Session.disableImageCache, let cachedImage = loadImageFromFile(url) {
                completion(cachedImage)  // photo has cached in file
            } else {
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        if !Session.disableImageCache { self.saveImageToFile(image, url) }  // cache image to file
                        DispatchQueue.main.async {
                            completion(image)  // photo loaded from server
                        }
                    }
                }
            }
        }
    }

    //------------- Image file caching
    
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
            return UIImage(data: imageData)
        } catch {
            print("Error occured while file loading: \(error)")
            return nil
        }
    }
    
    func clearAppImageCache() -> Bool {
        var res = true
        let dir = getCacheDir()
        guard let directory = dir else { return res }
        do {
            var filePaths = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            filePaths = filePaths.filter { !$0.hasDirectoryPath }
            for filePath in filePaths {
                try FileManager.default.removeItem(atPath: filePath.path)
            }
        } catch {
            res = false
            print("Could not clear folder: \(error)")
        }
        return res
    }
}
