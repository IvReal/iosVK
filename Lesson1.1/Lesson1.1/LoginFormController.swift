//  Вадим Иванов, СПб, Россия
//
//  LoginFormController.swift
//  Lesson1.1
//
//  Created by Iv on 28/02/2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    private var isAuthorized = false
    private let weatherKinds = [
        ("fine", UIColor.orange),
        ("awful", UIColor.darkGray),
        ("cloudless", UIColor(red: 0, green: 204, blue: 255, alpha: 255)),
        ("sunny", UIColor.yellow),
        ("rainy", UIColor.lightGray)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tap gesture -> hideKeyboard action
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        // initial form state
        welcomeLabel.text = nil
        updateLoginForm()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // keyboard show notification
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.keyboardWasShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        // keyboard hide notification
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        // set focus to login text field
        loginInput.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // SignIn/SignOut action handler
    @IBAction func signinTouch(_ sender: Any) {
        if !isAuthorized {
            // Sign In: assume that authorization is success then login and password are not empty...
            if let login = loginInput.text, let password = passwordInput.text {
                if login.isEmpty || password.isEmpty {
                    welcomeLabel.text = "Valid login and password required"
                } else {
                    let rand = Int(arc4random_uniform(UInt32(weatherKinds.count)))
                    if rand >= 0 && rand < weatherKinds.count {
                        let currentWeather =  weatherKinds[rand]
                        welcomeLabel.text = "Hi, \(login)!\nThe weather is \(currentWeather.0) today"
                        contentView?.backgroundColor = currentWeather.1
                    } else {
                        welcomeLabel.text = "Hi, \(login)!\nUnknown weather now:-("
                        contentView?.backgroundColor = UIColor.white
                    }
                    isAuthorized = true
                }
            }
        } else {
            isAuthorized = false // Sign Out
            passwordInput.text = nil
            welcomeLabel.text = nil
            contentView?.backgroundColor = UIColor.white
            // set focus to password text field
            passwordInput.becomeFirstResponder()
        }
        updateLoginForm()
    }
    
    // keyboard show notification handler
    @objc func keyboardWasShown(notification: Notification) {
        // keyboard size
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // set UIScrollView bottom indent
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    // keyboard hide notification handler
    @objc func keyboardWillBeHidden(notification: Notification) {
        // reset UIScrollView bottom indent
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }

    // hide keyboard action
    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }

    // set form content state depend on authorization status
    private func updateLoginForm() {
        loginLabel.isHidden = isAuthorized
        loginInput.isHidden = isAuthorized
        passwordLabel.isHidden = isAuthorized
        passwordInput.isHidden = isAuthorized
        signButton.setTitle(isAuthorized ? "Sign Out" : "Sign In", for: UIControl.State.normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
