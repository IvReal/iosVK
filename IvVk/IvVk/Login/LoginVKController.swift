//  LoginVKController.swift
//  IvVk
//  Created by Iv on 29/04/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import WebKit
import SwiftKeychainWrapper

class LoginVKController: UIViewController, WKNavigationDelegate {

    private let segSuccessLogin = "successVKLoginSegue"

    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    @IBOutlet weak var loadControl: LoadingControl!
    @IBOutlet weak var titleImage: UIImageView!
    
    // unwind logout action
    @IBAction func loginUnwind(unwindSegue: UIStoryboardSegue) {
        logout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.myLightBlue
        webView.backgroundColor = UIColor.myLightBlue
        Session.disableImageCache = UserDefaults.standard.bool(forKey: keyDisableCache)
        clearWebViewCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manageLoadingIndicator(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.login()
        })*/
        login()
    }
    
    private func manageLoadingIndicator(_ isSet: Bool)
    {
        webView.isHidden = isSet
        loadControl.alpha = isSet ? 1 : 0
        if isSet {
            loadControl.run()
        } else {
            webView.endEditing(true)
        }
    }
    
    // ---------- logout ----------
    
    private func logout() {
        clearWebViewCache()
        clearAppKeychains()
    }

    private func clearWebViewCache() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                 for: records.filter { $0.displayName.contains("vk") },
                                 completionHandler: {  })
        }
    }
    
    // ---------- login ----------
    
    private func login() {
        if let token = KeychainWrapper.standard.string(forKey: keyToken),
           let uid = KeychainWrapper.standard.integer(forKey: keyUid)
        {
            // if token exists in keychains, try to work with it
            print("Token and UserId loaded from keychain")
            saveSessionParams(token: token, uid: uid)
            checkTokenValid()
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
                URLQueryItem(name: "scope", value: Session.vkScope), 
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
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.manageLoadingIndicator(false)
                })
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
        saveSessionParams(token: params["access_token"] ?? "", uid: Int(params["user_id"] ?? "0") ?? 0)
        setAppKeychains()
        checkTokenValid()
    }
    
    // Проверка валидности токена (поскольку токен теперь может читаться из keychains, он может потерять актуальность)
    private func checkTokenValid() {
        /*VkUsersService().loadUser(Session.instance.userId) { [weak self] person in
            let user = person
            if user != nil {
                Session.instance.fio = user!.name
                saveUserConnectionToFirebase()
                self?.performSegue(withIdentifier: self!.segSuccessLogin, sender: self)
            } else {
                self?.logout()
                self?.login()
            }
        }*/
        let userServiceProxy = VkUsersServiceProxy(userService: VkUsersService())
        userServiceProxy.loadUser(Session.instance.userId) { [weak self] person in
            let user = person
            if user != nil {
                Session.instance.fio = user!.name
                saveUserConnectionToFirebase()
                self?.performSegue(withIdentifier: self!.segSuccessLogin, sender: self)
            } else {
                self?.logout()
                self?.login()
            }
        }
    }
    
    private func saveSessionParams(token: String, uid: Int) {
        if token != "" && uid > 0 {
            let session = Session.instance
            session.token = token
            session.userId = uid
        }
    }
}
