//  FriendVC.swift
//  Lesson1.1
//  Created by Iv on 15/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class FriendVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collView: UICollectionView!
    
    public var selectedFriend: Person?
    public var selectedFriends: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collView.isPagingEnabled = true
    }    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 1
        return selectedFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendCell
        /*if let sf = selectedFriend {
            cell.nameFriend.text = sf.name
            cell.fotoFriend.image = sf.foto
        }*/
        cell.nameFriend.text = selectedFriends[indexPath.row].name
        cell.fotoFriend.image = selectedFriends[indexPath.row].foto
        return cell
    }
    
    // Adjust collection view cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width  = collectionView.frame.width
        return CGSize(width: width, height: height)
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
