//  ServiceController.swift
//  IvVk
//  Created by Iv on 15/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class ServiceController: UIViewController {
    
    @IBOutlet weak var switchCache: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchCache.isOn = Session.disableImageCache
    }
    
    @IBAction func clearCache(_ sender: Any) {
        showConfirmAlertOk("Service", "Do you want to clear application images cache?") {
            let res = clearAppImageCache()
            self.showAlert("Service", res ? "Applicatioin images cache cleared successfully" : "Error occured while clearing application image cache")
        }
    }
    
    @IBAction func clearKeychains(_ sender: Any) {
        showConfirmAlertOk("Service", "Do you want to clear application Keychain data?") {
            manageKeychains(isClear: true)
            self.showAlert("Service", "Applicatioin Keychains removed")
        }
    }
    
    @IBAction func clearUserDefaults(_ sender: Any) {
        showConfirmAlertOk("Service", "Do you want to clear application UserDafaults?") {
            clearAppUserDefaults()
            self.showAlert("Service", "Applicatioin UserDefaults removed")
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        showConfirmAlertOk("Logout", "Are you sure to sign out?") {
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
        }
    }

    @IBAction func allowCache(_ sender: Any) {
        Session.disableImageCache = switchCache.isOn
        UserDefaults.standard.set(Session.disableImageCache, forKey: keyDisableCache)
    }
}
