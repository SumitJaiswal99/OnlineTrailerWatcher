//
//  APIHandler.swift
//  SocialMediaPlayer
//
//  Created by iPHTech 29 on 27/04/23.
//

import Foundation

let apiURLString = "https://api.themoviedb.org/3/trending/movie/day?api_key=877a86d2d8c4aac067a20c85737a59a5"
var valuesImageURL:String = ""

func getdataFromApi(completionHanler: @escaping ((Result<[MoviesList],Error>) -> Void)) {
    var apiMoviesData = [MoviesList]()
    guard let url = URL(string: apiURLString) else {
        print(" failed to get URL!")
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    URLSession.shared.dataTask(with: request) { data, response, error in
        if error == nil, let responseData = data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: responseData)
                let dataDict = jsonObject as! NSDictionary
                let countValue = dataDict.value(forKey: "page") as! Int
                let dataArray = dataDict.value(forKey: "results") as! NSArray
                for (_, value) in dataArray.enumerated() {
                    let valueData = value as! NSDictionary
                    
                    let titleNameData = valueData.value(forKey: "title") as! String
                    let imagePath = valueData.value(forKey: "backdrop_path") as! String
                    let voteAverageCountRating = valueData.value(forKey: "vote_average") as! Double
                    valuesImageURL = "https://image.tmdb.org/t/p/w500/\(imagePath)"
                    apiMoviesData.append(MoviesList(titleName: titleNameData, MoviesImageId: valuesImageURL, MoviesRating: voteAverageCountRating, favouriteArray: false))
                }
                completionHanler(.success(apiMoviesData))
            }
            catch let error {
                print(error.localizedDescription)
                //completionHanler(false)
            }
        }
        else{
            print("No data found")
        }
    }.resume()
}
