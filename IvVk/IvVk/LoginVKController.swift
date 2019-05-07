//  LoginVKController.swift
//  IvVk
//  Created by Iv on 29/04/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit
import WebKit

class LoginVKController: UIViewController, WKNavigationDelegate {

    private let segSuccessLogin = "successVKLoginSegue"

    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //logoutVK()
        
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
        let session = Session.instance
        // token
        session.token = params["access_token"] ?? ""
        session.userId = Int(params["user_id"] ?? "0") ?? 0
        //print("Access token is \(session.token), user ID is \(session.userId)")
        // success login segue
        decisionHandler(.cancel)
        performSegue(withIdentifier: segSuccessLogin, sender: self)
    }
    
    private func logoutVK() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                 for: records.filter { $0.displayName.contains("vk") },
                                 completionHandler: {  })
        }
    }
}
