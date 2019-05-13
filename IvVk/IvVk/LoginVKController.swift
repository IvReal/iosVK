//  LoginVKController.swift
//  IvVk
//  Created by Iv on 29/04/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import WebKit
import SwiftKeychainWrapper

class LoginVKController: UIViewController, WKNavigationDelegate {

    private let segSuccessLogin = "successVKLoginSegue"
    private let keyToken = "vkToken"
    private let keyUid = "vkUserId"

    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutVK()
        //clearKeychains()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = KeychainWrapper.standard.string(forKey: keyToken),
           let uid = KeychainWrapper.standard.integer(forKey: keyUid)
        {
            // TODO: check token is not expired
            print("Token and UserId loaded from keychain")
            saveSessionParams(token: token, uid: uid, saveToKeychain: false)
        } else {
            // VK login page in webView need to get token
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "oauth.vk.com"
            urlComponents.path = "/authorize"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Session.vkClientId),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "scope", value: "262150"),
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: Session.vkAPI)
            ]
            let request = URLRequest(url: urlComponents.url!)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        guard let url = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment  else {
                decisionHandler(.allow)
                return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        decisionHandler(.cancel)
        saveSessionParams(token: params["access_token"] ?? "", uid: Int(params["user_id"] ?? "0") ?? 0, saveToKeychain: true)
    }
    
    private func saveSessionParams(token: String, uid: Int, saveToKeychain: Bool, autoSegue: Bool = true) {
        if (token != "" && uid > 0) {
            let session = Session.instance
            session.token = token
            session.userId = uid
            if saveToKeychain {
                KeychainWrapper.standard.set(token, forKey: keyToken)
                KeychainWrapper.standard.set(uid, forKey: keyUid)
            }
            testUserDefaults()
            if autoSegue {
                performSegue(withIdentifier: segSuccessLogin, sender: self)
            }
        }
    }
    
    private func clearKeychains() {
        KeychainWrapper.standard.removeObject(forKey: keyToken)
        KeychainWrapper.standard.removeObject(forKey: keyUid)
    }
    
    private func logoutVK() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                 for: records.filter { $0.displayName.contains("vk") },
                                 completionHandler: {  })
        }
    }
    
    // test userdefaults
    private func testUserDefaults() {
        let key = "uid"
        UserDefaults.standard.set(String(Session.instance.userId), forKey: key)
        let uid = UserDefaults.standard.string(forKey: key) ?? ""
        print("Saved in UserDefaults UserId is \(uid)")
    }
    
    // filecaching methods
    static let cachedFileName = "image.png"
    private func getDir() -> URL? {
        return try? FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
    }
    
    private func saveImage(_ imageName: String, _ fileName: String) {
        let img = UIImage(named: imageName)
        let dir = getDir()
        guard let image = img, let directory = dir else { return }
        let path = directory.appendingPathComponent(fileName)
        do {
            try image.pngData()?.write(to: path)
            print("File saved successfully")
        } catch {
            print("Error occured while file saving: \(error)")
        }
    }
    
    private func loadImage(_ fileName: String) -> UIImage? {
        let dir = getDir()
        guard let directory = dir else { return nil }
        let path = directory.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: path)
            print("File loaded successfully")
            return UIImage(data: imageData)
        } catch {
            print("Error occured while file loading: \(error)")
            return nil
        }
    }
}
