//  Friend2VC.swift
//  IvVk
//  Created by Iv on 24/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class Friend2VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    var images: [Photo] = []
    var indexCurrent = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.myLightGreen

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        indexCurrent = -1
    }
    
    func assignImages(_ images: [Photo], _ index: Int) {
        self.images = images
        indexCurrent = index
        refreshImage()
    }
    
    func refreshImage() {
        if imageView != nil && indexCurrent >= 0 {
            imageLabel.text = getCurrentImageLabel()
            self.title = getTitle()
            images[indexCurrent].getFoto { [weak self] photo in
                self?.imageView.image = photo
            }
        }
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            if indexCurrent < images.count - 1 {
                indexCurrent += 1
                animate(backward: false)
            }
        } else if (sender.direction == .right) {
            if (indexCurrent > 0) {
                indexCurrent -= 1
                animate(backward: true)
            }
        }
    }
    
    func animate(backward isBackward: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: { _ in
            self.images[self.indexCurrent].getFoto { [weak self] photo in
                self?.imageView.image = photo
                self?.imageLabel.text = self?.getCurrentImageLabel()
                self?.title = self?.getTitle()
                
                self?.imageView.transform = .identity
                
                let tr1 = CATransition()
                tr1.duration = 0.5
                tr1.type = CATransitionType.push
                tr1.subtype = isBackward ? CATransitionSubtype.fromLeft : CATransitionSubtype.fromRight
                
                let tr2 = CATransition()
                tr2.duration = 0.5
                tr2.type = CATransitionType.fade
                
                self?.imageView.layer.add(tr1, forKey: nil)
                self?.imageLabel.layer.add(tr2, forKey: nil)
            }
       })
    }
    
    func getCurrentImageLabel() -> String {
        if images.count == 0 || indexCurrent < 0  {
            return ""
        } else {
            return images[indexCurrent].text ?? ""
        }
    }
    
    func getTitle() -> String {
        return "Photo \(indexCurrent + 1) of \(images.count)"
    }

}
