//  NewsData.swift
//  IvVk
//  Created by Iv on 31/05/2019.
//  Copyright © 2019 Iv. All rights reserved.//

import UIKit
import Alamofire

class NewsItem: Decodable
{
    var type: String?         // тип списка новости, соответствующий одному из значений параметра filters
    var source_id: Int?       // идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы)
    var date: Double?         // время публикации новости в формате unixtime
}

class PhotoNews: NewsItem
{
    var photos: [Photo]?      // фотографии новости
    
    enum CodingKeys: String, CodingKey {
        case type
        case source_id
        case date
        case photos
    }
    enum PhotosKeys: String, CodingKey {
        case count
        case items
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try values.decode(String.self, forKey: .type)
        self.source_id = try values.decode(Int.self, forKey: .source_id)
        self.date = try values.decode(Double.self, forKey: .date)
        let photosContainer = try values.nestedContainer(keyedBy: PhotosKeys.self, forKey: .photos)
        self.photos = try photosContainer.decode([Photo].self, forKey: .items)
    }
}

class PostNews: NewsItem
{
    var text: String?         // текст новости
    
    enum CodingKeys: String, CodingKey {
        case type
        case source_id
        case date
        case text
        case copy_history
    }
    enum RepostsKeys: String, CodingKey {
        case text
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try values.decode(String.self, forKey: .type)
        self.source_id = try values.decode(Int.self, forKey: .source_id)
        self.date = try values.decode(Double.self, forKey: .date)
        self.text = try values.decode(String.self, forKey: .text)
        if var reposts = try? values.nestedUnkeyedContainer(forKey: .copy_history) {
            if let repost = try? reposts.nestedContainer(keyedBy: RepostsKeys.self) {
                let addtext = try? repost.decode(String.self, forKey: .text)
                self.text = (self.text ?? "") + (addtext ?? "")
            }
        }
    }
}

class PhotoNewsServerResponse: Decodable
{
    let items: [PhotoNews]
    enum CodingKeys: String, CodingKey {
        case items
    }
    enum ResponseKeys: String, CodingKey {
        case response
    }
    required init(from decoder: Decoder) throws {
        let responseContainer = try decoder.container(keyedBy: ResponseKeys.self)
        let itemsContainer = try responseContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.items = try itemsContainer.decode([PhotoNews].self, forKey: .items)
    }
}

class PostNewsServerResponse: Decodable
{
    let items: [PostNews]
    enum CodingKeys: String, CodingKey {
        case items
    }
    enum ResponseKeys: String, CodingKey {
        case response
    }
    required init(from decoder: Decoder) throws {
        let responseContainer = try decoder.container(keyedBy: ResponseKeys.self)
        let itemsContainer = try responseContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.items = try itemsContainer.decode([PostNews].self, forKey: .items)
    }
}

class VkNewsService
{
    let newsfeedUrl = "https://api.vk.com/method/newsfeed.get"

    func loadPhotoNews(count: Int, completion: @escaping ([PhotoNews]) -> Void) {
        DispatchQueue.global().async {
            let pars = Session.instance.getParams(["count": String(count), "filters": "photo"])
            Alamofire.request(self.newsfeedUrl, parameters: pars).responseData { repsonse in
                var res: [PhotoNews] = []
                if let data = repsonse.value {
                    let list = try? JSONDecoder().decode(PhotoNewsServerResponse.self, from: data)
                    if let plist = list {
                        res = plist.items
                    }
                }
                DispatchQueue.main.async {
                    completion(res)
                }
            }
        }
    }

    func loadPostNews(count: Int, completion: @escaping ([PostNews]) -> Void) {
        DispatchQueue.global().async {
            let pars = Session.instance.getParams(["count": String(count), "filters": "post"])
            Alamofire.request(self.newsfeedUrl, parameters: pars).responseData { repsonse in
                var res: [PostNews] = []
                if let data = repsonse.value {
                    let list = try? JSONDecoder().decode(PostNewsServerResponse.self, from: data)
                    if let plist = list {
                        res = plist.items
                    }
                }
                DispatchQueue.main.async {
                    completion(res)
                }
            }
        }
    }
}
