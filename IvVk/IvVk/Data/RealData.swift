//  RealData.swift
//  IvVk
//  Created by Iv on 26/04/2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import Foundation

class Session {
    static let instance = Session()
    
    private init() {}
    
    public func clear() {
        login = nil
        fio = ""
        token = ""
        userId = 0
    }
    
    var login: String?
    var fio: String = ""
    var token: String = ""
    var userId: Int = 0
}
