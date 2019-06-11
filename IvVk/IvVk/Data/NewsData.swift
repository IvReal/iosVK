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
    var text: String?    // текст новости
    var likes: Likes?

    enum CodingKeys: String, CodingKey {
        case type
        case source_id
        case date
        case text
        case copy_history
        case likes
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
        self.likes = try values.decode(Likes.self, forKey: .likes)
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

    private func loadPhotoNews(completion: @escaping ([PhotoNews]) -> Void) {
        // создаем свою очередь и передаем ее параметром в метод responseData:
        // тогда вся деятельность Alamofire и completion будут происходить в этой очереди;
        // результат не перебрасываем в главный поток, поскольку эта функция не вызывается напрямую из интерфейса
        let getPhotoQueue = DispatchQueue(label: "getPhotoQueue", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)
        let pars = Session.instance.getParams(["filters": "photo"])
        Alamofire.request(self.newsfeedUrl, parameters: pars).responseData(queue: getPhotoQueue) { repsonse in
            //self.testThread("Parsing JSON") // убеждаемся, что работаем в фоновом потоке
            var res: [PhotoNews] = []
            if let data = repsonse.value {
                let list = try? JSONDecoder().decode(PhotoNewsServerResponse.self, from: data)
                if let plist = list {
                    res = plist.items
                }
            }
            completion(res)
        }
    }

    private func loadPostNews(completion: @escaping ([PostNews]) -> Void) {
        let getPostQueue = DispatchQueue(label: "getPostQueue", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)
        let pars = Session.instance.getParams(["filters": "post"])
        Alamofire.request(self.newsfeedUrl, parameters: pars).responseData(queue: getPostQueue) { repsonse in
            var res: [PostNews] = []
            if let data = repsonse.value {
                let list = try? JSONDecoder().decode(PostNewsServerResponse.self, from: data)
                if let plist = list {
                    res = plist.items
                }
            }
            completion(res)
        }
    }
    
    func loadNews(completion: @escaping ([NewsItem]) -> Void) {
        loadPhotoNews() { list in
            //self.testThread("LoadPhotoNews") // фоновый поток (см. loadPhotoNews)
            let photos = list
            self.loadPostNews() { list in
                //self.testThread("LoadPostNews") // фоновый поток
                let posts = list
                let allnews = (photos + posts).sorted(by: { $0.date! > $1.date! })
                DispatchQueue.main.async {
                    //self.testThread("Return result") // главный поток
                    completion(allnews)
                }
            }
        }
    }
    
    private func testThread(_ placeDescription: String)
    {
        print("\(placeDescription) on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
    }
}
