//  LoginFormController.swift
//  Lesson1.1
//  Created by Iv on 28/02/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class LoginFormController: UIViewController, UITextFieldDelegate {

    private let segSuccessLogin = "successLoginSegue"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tap gesture -> hideKeyboard action
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        // text fields return buttons on keyboard
        loginInput.delegate = self
        loginInput.returnKeyType = .continue
        passwordInput.delegate = self
        passwordInput.returnKeyType = .done
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
    
    // SignIn action handler
    @IBAction func signinTouch(_ sender: Any) {
        // Sign In: assume that authorization is success then login and password are not empty...
        if let login = loginInput.text, let password = passwordInput.text {
            if login.isEmpty || password.isEmpty {
                ShowAlert("Authorization", "Valid login and password required")
            } else {
                performSegue(withIdentifier: segSuccessLogin, sender: self)
            }
        }
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
    
    // keyboard return buttons handler
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === loginInput {
            passwordInput.becomeFirstResponder()
        } else if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            signinTouch(signButton)
        }
        return true
    }
    
    // unwind action
    @IBAction func loginUnwind(unwindSegue: UIStoryboardSegue) {
        loginInput.text = nil
        passwordInput.text = nil
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
