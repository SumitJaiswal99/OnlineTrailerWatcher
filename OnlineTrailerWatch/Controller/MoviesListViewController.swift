//
//  ViewController.swift
//  OnlineTrailerWatch
//
//  Created by iPHTech 29 on 07/04/23.
//

import UIKit
import Cosmos

class MoviesListViewController: UIViewController{
    
    //MARK: Define IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    let apiURLString = "https://api.themoviedb.org/3/trending/movie/day?api_key=877a86d2d8c4aac067a20c85737a59a5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouriteButton.setImage(UIImage(named: "favourite.png"), for: .normal)
        favouriteButton.layer.cornerRadius = 8
        getdataFromApi()
        favouriteArray = [Bool](repeating: false, count: 100)
        configureCustomRatingArray()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFavouritesArray(notification:)), name: Notification.Name("didTapAddFavouriteNotification"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }
    
    //MARK: Define All varibales
    var arraytitle = [String]()
    var favouriteArray = [Bool]()
    var arrayRating = [Double]()
    var imageArray = [String]()
    var customRatingArray = [MovieDetails]()
    var valuesImageURL:String = ""
    
  
    func getdataFromApi() {
        guard let url = URL(string: apiURLString) else {
            print(" failed to get URL!")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if error == nil, let responseData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: responseData)
                    print("\(jsonObject)")
                    let dataDict = jsonObject as! NSDictionary
                    let countValue = dataDict.value(forKey: "page") as! Int
                    print("page =\(countValue)")
                    let dataArray = dataDict.value(forKey: "results") as! NSArray
                    for (index, value) in dataArray.enumerated() {
                        let valueData = value as! NSDictionary
                        for i in 0...20 {
                            if index == i {
                                let indexDataDict = valueData.value(forKey: "title") as! String
                                let imagePath = valueData.value(forKey: "backdrop_path") as! String
                                let voteAverageCountRating = valueData.value(forKey: "vote_average") as! Double
                                print(voteAverageCountRating)
                        
                                DispatchQueue.main.async { [self] in
                                    arraytitle.append(indexDataDict)
                                    print(arraytitle[i])
                                    arrayRating.append(voteAverageCountRating)
                                    print(arrayRating[i])
                                    valuesImageURL = "https://image.tmdb.org/t/p/w500/\(imagePath)"
                                    imageArray.append(valuesImageURL)
                                    print(imageArray[i])
                                }
                                
                                DispatchQueue.main.async {
                                    self.myCollectionView.reloadData()
                                }
                               
                                print("indexDataDict =\(indexDataDict)")
                            }
                        }
                    }
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
            for (index, item) in arraytitle.enumerated() {
                if item == title {
                    favouriteArray[index] = true
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
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
       
        let width = (collectionView.frame.size.width)
        print(width)
        
        return CGSize(width: width, height: width/2 + 105 )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        cell.titlesPosterUIImageView.contentMode = .scaleAspectFill
    
        if favouriteArray.count > 0{
            if favouriteArray[indexPath.row]{
                cell.heartButton.setImage(UIImage(named: "filled.png"), for: .normal)
            }
            else {
                cell.heartButton.setImage(UIImage(named: "unfilled.png"), for: .normal)
            }
        }
        
        if arraytitle.count > 0 && indexPath.row < arraytitle.count {
            
            cell.titleLabel.text = arraytitle[indexPath.row]
            let correctValue = arrayRating[indexPath.row]
            
            let apiURLStrings = "\(imageArray[indexPath.row])"
            print(apiURLStrings)
            cell.titlesPosterUIImageView.downloaded(from: apiURLStrings)
            //show custom rating
            let titleValue = arraytitle[indexPath.row]
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
        vc?.titleName = arraytitle[indexPath.row]
        vc?.videosIdImage = imageArray[indexPath.row]
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


