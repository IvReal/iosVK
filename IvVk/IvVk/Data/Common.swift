//  RealData.swift
//  IvVk
//  Created by Iv on 26/04/2019.
//  Copyright © 2019 Iv. All rights reserved.

import Foundation
import UIKit
import Alamofire
import SwiftKeychainWrapper

//------------- Session

class Session {
    static let instance = Session()
    static let vkAPI = "5.95"
    static let vkClientId = "6964606"
    static let allowImageCaching = false

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

let keyToken = "vkToken"
let keyUid = "vkUserId"

func manageKeychains(isClear: Bool) {
    if isClear {
        KeychainWrapper.standard.removeObject(forKey: keyToken)
        KeychainWrapper.standard.removeObject(forKey: keyUid)
    } else {
        KeychainWrapper.standard.set(Session.instance.token, forKey: keyToken)
        KeychainWrapper.standard.set(Session.instance.userId, forKey: keyUid)
    }
}
