//  NewsData.swift
//  IvVk
//  Created by Iv on 31/05/2019.
//  Copyright © 2019 Iv. All rights reserved.//

import UIKit
import Alamofire

class NewsItem : Decodable {
    var type: String?         // тип списка новости, соответствующий одному из значений параметра filters
    var source_id: Int?       // идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы)
    var date: Double?         // время публикации новости в формате unixtime
    var photo: Photo?         // первая фотография новости типа "photo"
    var text: String?         // текст новости типа "post" или "photo"
    
    enum CodingKeys: String, CodingKey {
        case type
        case source_id
        case date
        case photos
        case text
        case copy_history
    }
    enum PhotosKeys: String, CodingKey {
        case count
        case items
    }
    enum RepostsKeys: String, CodingKey {
        case text
    }
    /*
     {
     "response": {
        "items":[{
            "type":"photo",
            "source_id":455264,
            "date":1559846278,
            "photos":{
                "count":1,
                "items":[{
                    "id":456241788,
                    "album_id":5941062,
                    "owner_id":455264,
                    "sizes":[{
                        "type":"m",
                        "url":"https:\/\/sun9-26.userapi.com\/c850328\/v850328255\/1614a1\/wZ_bSbZG4YQ.jpg",
                        "width":97,
                        "height":130
                    }],
                    "text":"будни нашего дома:) Витя и Дуся",
                    "date":1559846278,
                    "access_key":"0f0ff4111ecdb6428e",
                    "likes":{
                        "user_likes":0,
                        "count":3
                    },
                    "reposts":{
                        "count":0,
                        "user_reposted":0
                    },
                    "comments":{
                        "count":0
                    },
                    "can_comment":1,
                    "can_repost":1
                }]  // photos-items
            }, // photos
            "post_id":1559768400
       } // item of items
     
     {
     "response":{
        "items":[{
            "type":"post",
            "source_id":214784243,
            "date":1559892505,
            "post_type":"post",
            "text":"",
            "copy_history":[{
                "id":5728,
                "owner_id":-1323295,
                "from_id":-1323295,
                "date":1559887382,
                "post_type":"post",
                "text":"Жюри конкурса детского рисунка...
    */
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try values.decode(String.self, forKey: .type)
        self.source_id = try values.decode(Int.self, forKey: .source_id)
        self.date = try values.decode(Double.self, forKey: .date)
        if self.type == "photo" {
            let photosContainer = try values.nestedContainer(keyedBy: PhotosKeys.self, forKey: .photos)
            let photos = try? photosContainer.decode([Photo].self, forKey: .items)
            self.photo = photos?.first
        }
        else if self.type == "post" {
            self.text = try values.decode(String.self, forKey: .text)
            if var reposts = try? values.nestedUnkeyedContainer(forKey: .copy_history) {
                if let repost = try? reposts.nestedContainer(keyedBy: RepostsKeys.self) {
                    let addtext = try? repost.decode(String.self, forKey: .text)
                    self.text = (self.text ?? "") + (addtext ?? "")
                }
            }
        }
    }
}

class NewsServerResponse : Decodable {
    let items: [NewsItem]
    enum CodingKeys: String, CodingKey {
        case items
    }
    enum ResponseKeys: String, CodingKey {
        case response
    }
    required init(from decoder: Decoder) throws {
        let responseContainer = try decoder.container(keyedBy: ResponseKeys.self)
        let itemsContainer = try responseContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.items = try itemsContainer.decode([NewsItem].self, forKey: .items)
    }
}

// load news
func loadNewsList(count: Int, filters: String, completion: @escaping ([NewsItem]) -> Void ) {
    let pars = Session.instance.getParams(["count": String(count), "filters": filters])
    Alamofire.request("https://api.vk.com/method/newsfeed.get", parameters: pars).responseData { repsonse in
        var res: [NewsItem] = []
        if let data = repsonse.value {
            let list = try? JSONDecoder().decode(NewsServerResponse.self, from: data)
            if let plist = list {
                res = plist.items
            }
        }
        completion(res)
    }
}
