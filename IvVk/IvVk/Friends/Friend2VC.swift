//  Friend2VC.swift
//  Lesson1.1
//  Created by Iv on 24/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class Friend2VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    //var images: [UIImage] = []
    var images: [Photo] = []
    var indexCurrent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageView.image = images.count > 0 ? images[0] : nil
        //imageLabel.text = getCurrentImageLabel()
        imageLabel.text = ""

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func loadUserPhotos(userId: Int) {
        images = []
        loadPhotosList(owner: userId) { photos in
            self.images = photos
            if self.images.count > 0 {
                self.images[0].getFoto { photo in
                    self.imageView.image = photo
                    self.imageLabel.text = self.getCurrentImageLabel()
                }
            }
            self.imageLabel.text = self.getCurrentImageLabel()
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
            //self.imageView.image = self.images[self.indexCurrent]
            //self.imageLabel.text = self.getCurrentImageLabel()
            self.images[self.indexCurrent].getFoto { photo in
                self.imageView.image = photo
                self.imageLabel.text = self.getCurrentImageLabel()
                
                self.imageView.transform = .identity
                
                let tr1 = CATransition()
                tr1.duration = 0.5
                tr1.type = CATransitionType.push
                tr1.subtype = isBackward ? CATransitionSubtype.fromLeft : CATransitionSubtype.fromRight
                
                let tr2 = CATransition()
                tr2.duration = 0.5
                tr2.type = CATransitionType.fade
                
                self.imageView.layer.add(tr1, forKey: nil)
                self.imageLabel.layer.add(tr2, forKey: nil)
            }
       })
    }
    
    func getCurrentImageLabel() -> String {
        return images.count > 0 ? "image \(indexCurrent + 1) of \(images.count)" : "No images"
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
