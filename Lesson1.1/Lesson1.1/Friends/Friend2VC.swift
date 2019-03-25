//  Friend2VC.swift
//  Lesson1.1
//  Created by Iv on 24/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class Friend2VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var images: [UIImage] = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if images.count > 0 {
            imageView.image = images[0]
        }
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view.
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            if index < images.count - 1 {
                index += 1
                animate(backward: false)
            }
        } else if (sender.direction == .right) {
            if (index > 0) {
                index -= 1
                animate(backward: true)
            }
        }
    }
    
    func animate(backward isBackward: Bool) {
        UIView.animate(withDuration: 1, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: { _ in
            self.imageView.image = self.images[self.index]
            let tr = CATransition()
            tr.duration = 1
            tr.type = CATransitionType.moveIn
            tr.subtype = isBackward ? CATransitionSubtype.fromLeft : CATransitionSubtype.fromRight
            self.imageView.layer.add(tr, forKey: nil)
            self.imageView.transform = .identity
        })
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
