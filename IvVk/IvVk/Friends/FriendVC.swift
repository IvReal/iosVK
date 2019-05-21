//  FriendVC.swift
//  Lesson1.1
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class FriendVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collView: UICollectionView!
    
    var images: [Photo] = []
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collView.isPagingEnabled = true
    }    
    
    func loadUserPhotos(userId: Int, userName: String?) {
        images = []
        self.title = userName
        loadPhotosList(owner: userId) { photos in
            self.images = photos
            self.collView.reloadData()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendCell
        let photo = images[indexPath.row]
        cell.loadCell(photo: photo)
        return cell
    }
    
    // Adjust collection view cell size
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width  = collectionView.frame.width
        return CGSize(width: width, height: height)
    }*/

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let fc2 = segue.destination as? Friend2VC {
            fc2.assignImages(images, index)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "showFriend2", sender: nil)
    }
}
