//  ServiceController.swift
//  IvVk
//  Created by Iv on 15/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class ServiceController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clearCache(_ sender: Any) {
        showConfirmAlert("Service", "Do you want to clear application images cache?") { [weak self] result in
            if result {
                clearAppImageCache()
                // TODO: check errors while cache clearing
                self?.showAlert("Service", "Applicatioin images cache cleared")
            }
        }
    }
    
    @IBAction func clearKeychains(_ sender: Any) {
        showConfirmAlert("Service", "Do you want to clear application Keychain data?") { [weak self] result in
            if result {
                manageKeychains(isClear: true)
                self?.showAlert("Service", "Applicatioin Keychains removed")
            }
        }
    }
    
    @IBAction func clearUserDefaults(_ sender: Any) {
        showConfirmAlert("Service", "Do you want to clear application UserDafaults?") { [weak self] result in
            if result {
                //clearAppUserDefaults(isClear: true) // TODO
                self?.showAlert("Service", "Applicatioin UserDefaults removed")
            }
        }
    }

    @IBAction func signOut(_ sender: Any) {
        showConfirmAlert("Logout", "Are you sure to sign out?") { [weak self] result in
            if result {
                self?.performSegue(withIdentifier: "logoutSegue", sender: self)
            }
        }
    }
}
