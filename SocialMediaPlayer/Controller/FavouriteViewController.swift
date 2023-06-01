//
//  FavouriteViewController.swift
//  SocialMediaPlayer
//
//  Created by iPHTech 29 on 19/04/23.
//

import UIKit
import youtube_ios_player_helper

class FavouriteViewController: UIViewController, YTPlayerViewDelegate {
    
    //MARK: Define IBOutlet
    @IBOutlet weak var myCollectionView: UICollectionView!
   
    //MARK: Define All varibales
    var Arraytitle = [String]()
    var ArrayVideosId = [String]()
    var titleNameString = ""
    var VideosIdValue = ""
    var HeartButtonIcon = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        apppendvalue()
    }
    
    func apppendvalue() {
        
        Arraytitle = UserDefaults.standard.array(forKey: "titleName") as? [String] ?? []
        ArrayVideosId = UserDefaults.standard.array(forKey: "videosId") as? [String] ?? []

        if !Arraytitle.contains(titleNameString) && titleNameString != " " {
            Arraytitle.append(titleNameString)
            ArrayVideosId.append(VideosIdValue)
            UserDefaults.standard.set(Arraytitle, forKey: "titleName")
            UserDefaults.standard.set(ArrayVideosId, forKey: "videosId")
            
        }
        print("value=====",Arraytitle)
        print("value=====",ArrayVideosId)
    }
}

extension FavouriteViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Arraytitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCell", for: indexPath as IndexPath) as! FavouriteCollectionViewCell
        let otherPlayer = YTPlayerView()
        view.addSubview(otherPlayer)
        cell.favouriteMoviesView.delegate = self
       cell.favouriteMoviesView.load(withVideoId: "\(ArrayVideosId[indexPath.row])",playerVars: ["playsinline": 1])
        cell.MoviestitleLabel.text = Arraytitle[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        print(width)
        return CGSize(width: width, height: width/2 + 70)
    }
    
}
