//  Functions.swift
//  Lesson1.1
//  Created by Iv on 20/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    func ShowAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

