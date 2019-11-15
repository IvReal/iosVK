//  ServiceController.swift
//  IvVk
//  Created by Iv on 15/05/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class ServiceController: UIViewController {
    
    @IBOutlet weak var switchCache: UISwitch!
    @IBOutlet weak var btnClearImageCache: UIButton!
    @IBOutlet weak var btnClearAppKeychain: UIButton!
    @IBOutlet weak var btnClearAppUserDefaults: UIButton!
    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var lblCache: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColors(self.view, btnClearImageCache, btnClearAppKeychain, btnClearAppUserDefaults, btnSignOut, lblCache)
        switchCache.isOn = Session.disableImageCache
    }
    
    private func setColors(_ views: UIView...) {
        for view in views {
            if let button = (view as? UIButton) {
                button.backgroundColor = UIColor.myDarkBlue
                button.setTitleColor(UIColor.white, for: UIControl.State.normal)
            } else if let label = (view as? UILabel) {
                label.textColor = UIColor.white
            } else {
                view.backgroundColor = UIColor.myLightBlue
            }
        }
    }
    
    @IBAction func clearCache(_ sender: Any) {
        showConfirmAlertOk("Service", "Do you want to clear application images cache?") {
            let res = VkPhotoService.instance.clearAppImageCache()
            self.showAlert("Service", res ? "Applicatioin images cache cleared successfully" : "Error occured while clearing application image cache")
        }
    }
    
    @IBAction func clearKeychains(_ sender: Any) {
        showConfirmAlertOk("Service", "Do you want to clear application Keychain data?") {
            clearAppKeychains()
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
