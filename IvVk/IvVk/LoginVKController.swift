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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
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
        print("Access token is \(session.token), user ID is \(session.userId)")
        // friends
        PrintVkApiAnswer("friends.get",
                         ["user_id": String(Session.instance.userId), "fields": "online"])
        // photos
        PrintVkApiAnswer("photos.getAll",
                         ["owner_id": String(Session.instance.userId), "count": "2"])
        // user groups
        PrintVkApiAnswer("groups.get",
                         ["user_id": String(Session.instance.userId), "extended": "1"])
        // search groups
        PrintVkApiAnswer("groups.search",
                         ["q": "Travel", "count": "10"])

        decisionHandler(.cancel)
        performSegue(withIdentifier: segSuccessLogin, sender: self)
    }
    
    private func PrintVkApiAnswer(_ method: String, _ params: [String: String]) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/\(method)"
        // required params
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: Session.vkAPI)
        ]
        // specific params
        for (key, val) in params {
            urlConstructor.queryItems?.append(URLQueryItem(name: key, value: val))
        }
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let json = json {
                        print("\(method): \(json)")
                    }
                }
            }
        }
        task.resume()
    }
}
