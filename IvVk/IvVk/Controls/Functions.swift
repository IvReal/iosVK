//  Functions.swift
//  Lesson1.1
//  Created by Iv on 20/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(_ title: String, _ message: String, completion: @escaping (_ result: Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
            completion(false)
        }))
        present(alert, animated: true, completion: nil)
    }
}

