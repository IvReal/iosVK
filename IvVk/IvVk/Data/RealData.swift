//  RealData.swift
//  IvVk
//  Created by Iv on 26/04/2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import Foundation

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
    
    var login: String? { return userId > 0 ? String(userId) : nil  }
    var fio: String = ""
    var token: String = ""
    var userId: Int = 0
}
