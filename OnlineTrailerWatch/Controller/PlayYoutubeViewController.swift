//
//  PlayYoutubeViewController.swift
//  OnlineTrailerWatch
//
//  Created by iPHTech 29 on 10/04/23.
// OnlineTrailerWatch

import UIKit
import youtube_ios_player_helper

class PlayYoutubeViewController: UIViewController, YTPlayerViewDelegate {
    
    //MARK: Define All IBOutlets
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var giveRationButton: UIButton!
    @IBOutlet weak var mytitleLabelName: UILabel!
    
    
    //MARK: Define All varibales
    var titleName = " "
    var videosId = ""
    var videosIdImage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        mytitleLabelName.text = titleName
        let otherPlayer = YTPlayerView()
        view.addSubview(otherPlayer)
        playerView.delegate = self
        getVideoId()
        
        favouriteButton.layer.cornerRadius = 5
        giveRationButton.layer.cornerRadius = 5
        
    }
    //MARK: Give Videos Rating Action By User
    @IBAction func giveVideosRatingAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GivenRatingViewController") as? GivenRatingViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        vc?.videoIDForRating = videosId
        vc?.titleName = titleName
        vc?.videosImageForRating = videosIdImage
    }
    
    //MARK: Add favourite movies Action By User
    @IBAction func AddFavouriteMovies(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FavouriteViewController") as? FavouriteViewController
        
        vc?.VideosIdValue = videosId
        vc?.titleNameString = titleName
        
        let titleDict:[String: String] = ["title": titleName]
        NotificationCenter.default.post(name: Notification.Name("didTapAddFavouriteNotification"), object: nil, userInfo: titleDict)
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getVideoId() {
        var apiURLString = "https://youtube.googleapis.com/youtube/v3/search?q=\(titleName)&key=AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g".addpercent()
        
        guard let url = URL(string: apiURLString) else {
            print(" failed to get URL!")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if error == nil, let responseData = data {
                do {
                    let jsonData = try JSONDecoder().decode(VideoModel.self, from: responseData)
                    print(jsonData.items[0].id.videoID)
                    
                    print(videosId)
                    DispatchQueue.main.async {
                        videosId = jsonData.items[0].id.videoID
                        self.playerView.load(withVideoId: "\(jsonData.items[0].id.videoID)",playerVars: ["playsinline": 1])
                        
                    }
                    
                    print("https://www.youtube.com/watch?v=\(jsonData.items[0].id.videoID)")
                    
                }
                catch let error {
                    print(error.localizedDescription)
                }
                
            }
            else{
                print("No data found")
            }
        }.resume()
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}

extension  String {
    func addpercent() -> String{
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
