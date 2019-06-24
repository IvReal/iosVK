//  Common.swift
//  IvVk
//  Created by Iv on 26/04/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import Alamofire
import SwiftKeychainWrapper
import FirebaseFirestore

//------------- Session

class Session {
    static let instance = Session()
    static let vkAPI = "5.95"
    static let vkClientId = "6964606"
    static let vkScope = "270342"  // битовая маска прав (262144(группы)+8192(стена)+4(фото)+2(друзья)) // 262150
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

class CommomHelper
{
    static let instance = CommomHelper()
    private init() {}
    
    let minMask = "dd.MM.yyyy HH.mm"
    let secMask = "dd.MM.yyyy HH:mm:ss"
    let sctMask2 = "yyyyMMddHHmmss"
    
    private let dateFormatter: DateFormatter = {
        return DateFormatter()
    }()
    
    func getDateStringFromUnixTime(time: Double?) -> String
    {
        guard let time = time else { return "" }
        let date = Date(timeIntervalSince1970: time)
        dateFormatter.dateFormat = minMask
        return dateFormatter.string(from: date)
    }
    
    func getDateKeyAndDateString() -> (key: String, str: String)
    {
        let date = Date()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let strDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let strKey = dateFormatter.string(from: date)
        return (key: strKey, str: strDate)
    }
    
    func testThread(_ placeDescription: String)
    {
        print("\(placeDescription) on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
    }
}

/*func downloadFile(url: URL, pars: Parameters)
{
    let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
    Alamofire.download(
        url,
        method: .get,
        parameters: pars,
        encoding: JSONEncoding.default,
        headers: nil,
        to: destination).downloadProgress(closure: { (progress) in
            //progress closure
        }).response(completionHandler: { (DefaultDownloadResponse) in
            //here you able to access the DefaultDownloadResponse
            //result closure
        })
}*/

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

//------------- Firebase

func saveUserConnectionToFirebase() {
    DispatchQueue.global(qos: .background).async {
        let db = Firestore.firestore()
        let dateTuple = CommomHelper.instance.getDateKeyAndDateString()
        db.collection("user_activity").document(dateTuple.key).setData([
            "user": Session.instance.fio.split(separator: " ").first ?? "",
            "userid": Session.instance.userId,
            "time": dateTuple.str
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
}
