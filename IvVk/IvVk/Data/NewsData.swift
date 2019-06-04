//  NewsData.swift
//  IvVk
//  Created by Iv on 31/05/2019.
//  Copyright © 2019 Iv. All rights reserved.//

import UIKit
import Alamofire

class NewsItem : Decodable {
    var type: String?       // тип списка новости, соответствующий одному из значений параметра filters
    var source_id: Int?     // идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы)
    var date: Double?       // время публикации новости в формате unixtime
    //var photos: PhotosList2?
    var photoitems: [Photo]?
    
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
    enum PhotoKeys: String, CodingKey {
        case id
        case text
        case date
        case likes
        case sizes
    }
    /*
{"response":
     {"items":[
        {"type":"wall_photo",
         "source_id":218005513,
         "date":1559507775,
         "photos":
            {"count":1,
             "items":[
               {"id":456247350,
                "album_id":-7,
                "owner_id":218005513,
                "sizes":[ ]
                "text":"",
                "date":1559507771,
                "post_id":9017,
                "access_key":"2f03a6f95ca9b099b1",
                "likes":{"user_likes":0,"count":2},
                "reposts":{"count":0,"user_reposted":0},
                "comments":{"count":0},
                "can_comment":1,
                "can_repost":1}
                    ]}
     */
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try values.decode(String.self, forKey: .type)
        self.source_id = try values.decode(Int.self, forKey: .source_id)
        self.date = try values.decode(Double.self, forKey: .date)
        //self.photos = try values.decode(PhotosList2.self, forKey: .photos)
        let photos = try values.nestedContainer(keyedBy: PhotosKeys.self, forKey: .photos)
        var phitems = try photos.nestedUnkeyedContainer(forKey: .items)
        //self.photoitems = try phitems.decode([Photo].self)
        photoitems = []
        while !phitems.isAtEnd {
            let phitem = try phitems.nestedContainer(keyedBy: PhotoKeys.self)
            let cnt = try phitem.decode(Int.self, forKey: .id)
            print("\(cnt)")
            //let ph = try phitem.decode(Photo.self, forKey: .items)
            //self.photoitems!.append(ph)
        }
    }
}

class NewsList : Decodable {
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

/*class PhotosList2 : Decodable {
    let count: Int
    let items: [Photo]
    enum CodingKeys: String, CodingKey {
        case count
        case items
    }
    required init(from decoder: Decoder) throws {
        let itemsContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try itemsContainer.decode(Int.self, forKey: .count)
        self.items = try itemsContainer.decode([Photo].self, forKey: .items)
    }
}*/

// load news
func loadNewsList(count: Int, filters: String, completion: @escaping ([NewsItem]) -> Void ) {
    let pars = Session.instance.getParams(["count": String(count), "filters": filters])
    Alamofire.request("https://api.vk.com/method/newsfeed.get", parameters: pars).responseData { repsonse in
        var res: [NewsItem] = []
        if let data = repsonse.value {
            let list = try? JSONDecoder().decode(NewsList.self, from: data)
            if let plist = list {
                res = plist.items
            }
        }
        completion(res)
    }
}
