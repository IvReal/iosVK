//  Common.swift
//  IvVk
//  Created by Iv on 26/04/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import Alamofire
import SwiftKeychainWrapper

//------------- Session

class Session {
    static let instance = Session()
    static let vkAPI = "5.95"
    static let vkClientId = "6964606"
    static var disableImageCache = false

    var fio: String = ""
    var token: String = ""
    var userId: Int = 0

    private init() {}
    
    public func clear() {
        fio = ""
        token = ""
        userId = 0
    }
    
    public func getParams(_ params: [String: String]) -> Parameters {
        // common params
        var res: Parameters = [
            "access_token": token,
            "v": Session.vkAPI,
        ]
        // specific params
        for (key, val) in params {
            res[key] = val;
        }
        return res
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
                    if !Session.disableImageCache { saveImageToFile(image, url) }  // cache image to file
                    DispatchQueue.main.async {
                        completion(image)  // photo loaded from server
                    }
                }
            }
        }
    }
}

//------------- Keychains

let keyToken = "vkToken"
let keyUid = "vkUserId"

func setAppKeychains() {
    KeychainWrapper.standard.set(Session.instance.token, forKey: keyToken)
    KeychainWrapper.standard.set(Session.instance.userId, forKey: keyUid)
}

func clearAppKeychains() {
    KeychainWrapper.standard.removeObject(forKey: keyToken)
    KeychainWrapper.standard.removeObject(forKey: keyUid)
}

//------------- UserDefaults

let keyDisableCache = "udNoCache"

func clearAppUserDefaults() {
    UserDefaults.standard.removeObject(forKey: keyDisableCache)
}

