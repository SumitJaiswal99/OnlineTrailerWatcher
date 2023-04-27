//
//  ViewController.swift
//  SocialMediaPlayer
//
//  Created by iPHTech 29 on 07/04/23.
//

import UIKit
import Cosmos

class MoviesListViewController: UIViewController{

    //MARK: Define IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    //MARK: Define varibale
    var customRatingArray = [MovieDetails]()
    var MoviesListArray = [MoviesList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteButton.setImage(UIImage(named: "favourite.png"), for: .normal)
        favouriteButton.layer.cornerRadius = 8
   
        configureCustomRatingArray()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFavouritesArray(notification:)), name: Notification.Name("didTapAddFavouriteNotification"), object: nil)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        getdataFromApi { result in
            switch result{
            case .success(let movieData):
                self.MoviesListArray = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error Found")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:Jump to favourite view controller
    @IBAction func favouriteAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FavouriteViewController") as? FavouriteViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func configureCustomRatingArray() {
        if let ratings = UserDefaultsManager.shared.getAllCustomRating() {
            //data found
            customRatingArray = ratings
        }
        else{
            //data not found
            customRatingArray = []
        }
    }
    
    @objc func refreshFavouritesArray(notification: Notification){
        if let title = notification.userInfo?["title"] as? String {
            for (index, item) in MoviesListArray.enumerated() {
                if item.titleName == title {
                    MoviesListArray[index].favouriteArray = true
                    }
                }
            }
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }
}

extension MoviesListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width)
        return CGSize(width: width, height: width/2 + 105 )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoviesListArray.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        cell.titlesPosterUIImageView.contentMode = .scaleAspectFill
    
        if MoviesListArray.count > 0{
            if MoviesListArray[indexPath.row].favouriteArray {
                cell.heartButton.setImage(UIImage(named: "filled.png"), for: .normal)
            }
            else {
                cell.heartButton.setImage(UIImage(named: "unfilled.png"), for: .normal)
            }
        }
        
        if MoviesListArray.count > 0 && indexPath.row < MoviesListArray.count {
            cell.titleLabel.text = MoviesListArray[indexPath.row].titleName
            let correctValue = MoviesListArray[indexPath.row].MoviesRating
            let apiURLStrings = "\(MoviesListArray[indexPath.row].MoviesImageId)"
            cell.titlesPosterUIImageView.downloaded(from: apiURLStrings)
            //show custom rating
               let titleValue = MoviesListArray[indexPath.row].titleName
            let ratingArray = customRatingArray.filter({
                $0.title == titleValue
            })
            if ratingArray.count > 0{
                cell.showselfratingLabel.text = "\(String(describing: ratingArray.last?.rating ?? 0.0))"
            }
            else {
                cell.showselfratingLabel.text = "☆"
            }
            
            if cell.showselfratingLabel.text != "☆" {
                cell.showStarRating.rating = ratingArray.last?.rating ?? 0.0
            } else {
                cell.showStarRating.rating = correctValue
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainS = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainS.instantiateViewController(withIdentifier: "PlayYoutubeViewController") as? PlayYoutubeViewController
        vc?.titleName = MoviesListArray[indexPath.row].titleName
        vc?.videosIdImage = MoviesListArray[indexPath.row].MoviesImageId
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}


