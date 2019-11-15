//  FriendVC.swift
//  IvVk
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class FriendVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collView: UICollectionView!
    
    var images: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.backgroundColor = UIColor.myLightGreen
        self.view.backgroundColor = UIColor.myLightGreen
    }
    
    func loadUserPhotos(userId: Int, userName: String?) {
        images = []
        self.title = userName
        VkPhotoService.instance.loadPhotosList(owner: userId) { [weak self] photos in
            self?.images = photos
            self?.collView.reloadData()
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

    // Perform manual segue "showFriend2" on select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriend2", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? Friend2VC,
           let selPaths = collView.indexPathsForSelectedItems, selPaths.count > 0 {
            vc.assignImages(images, selPaths[0].row)
        }
    }
}
