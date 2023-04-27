//
//  GivenRatingViewController.swift
//  SocialMediaPlayer
//
//  Created by iPHTech 29 on 17/04/23.
//

import UIKit
import Cosmos
import SDWebImage

enum UserDefaultsKeys : String {
    case countRatingKey
    case VideosID
}
class GivenRatingViewController: UIViewController {
    
    //MARK: Define All IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var saveRatingButton: UIButton!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var slidder: UISlider!
    @IBOutlet weak var countRating: CosmosView!
    
    //MARK: Define All varibales
    var videoIDForRating = ""
    var countRatingKeyValues = ""
    var titleName: String = ""
    var videosImageForRating = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveRatingButton.layer.cornerRadius = 5
        countRating.settings.fillMode = .half
        slidder.minimumValue = 0
        slidder.maximumValue = 9
        showThumbnail()
        
    }
   
    func showThumbnail() {
        videoTitleLabel.text = titleName
        thumbnailImageView.sd_setImage(with: URL(string: "\(videosImageForRating)"))
    }
  
    //MARK: Save Rating Action
    @IBAction func saveratingAction(_ sender: Any) {
        print("Storing data..")
        let data = MovieDetails(movieId: videoIDForRating, rating: Double(countRatingKeyValues) ?? 0.0, isFavourite: false,title: titleName)
        UserDefaultsManager.shared.addData(movieRating: data)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MoviesListViewController") as? MoviesListViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    //MARK: Given Rating By Slider Action
    @IBAction func giveRatingAction(_ sender: UISlider) {
        countRating.rating = Double(sender.value)
        countRatingKeyValues = "\(Double(round(10 * countRating.rating) / 10))"
    }
}

