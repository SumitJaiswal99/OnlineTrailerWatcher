//
//  UserDefaultsManager.swift
//  OnlineTrailerWatch
//
//  Created by iPHTech 29 on 18/04/23.
//

import Foundation

var HeartButtonIcon = false

struct MovieDetails: Codable {
    var movieId: String
    var rating: Double
    var isFavourite: Bool
    var title: String
}

var MovieDetailsArray = [MovieDetails]()

class UserDefaultsManager {
    
    var moviekey = "MovieRatingKey"
    
    let defaults = UserDefaults.standard
    
    static let shared = UserDefaultsManager()
    
    public func addData(movieRating: MovieDetails) {
        var movieFound = false
        /*
         check key present
            get data
            check videoId is already present
                update data
            else append a new row in array
         else
            save data first time
         */
        
        //check key present
        if let MovieData = defaults.object(forKey: moviekey){
            do {
                let decoder = JSONDecoder()
                // get data
                var movieArray:[MovieDetails] = try decoder.decode([MovieDetails].self, from: MovieData as! Data)
                // check videoId is already present
                for (index, item) in movieArray.enumerated() {
                    if item.movieId == movieRating.movieId {
                        movieFound = true
                        //update data
                        movieArray[index].rating = movieRating.rating
                        movieArray[index].isFavourite = movieRating.isFavourite
                        movieArray[index].title = movieRating.title
                    }
                }
               //append a new row in array
                if !movieFound {
                    movieArray.append(movieRating)
                }
                
                // save data
                let encoder = JSONEncoder()
                let data = try encoder.encode(movieArray)
                UserDefaults.standard.set(data, forKey: moviekey)

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        // save data first time
        else{
            do{
                let MovieData:[MovieDetails] = [movieRating]
                // save data
                let encoder = JSONEncoder()
                let data = try encoder.encode(MovieData)
                UserDefaults.standard.set(data, forKey: moviekey)
            }
            catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    
    public func getData(movieId: String) -> MovieDetails?{
        if let MovieData = defaults.object(forKey: moviekey){
            do {
                let decoder = JSONDecoder()
                // get data
                let movieArray:[MovieDetails] = try decoder.decode([MovieDetails].self, from: MovieData as! Data)
                // check videoId is already present
                for (_, item) in movieArray.enumerated() {
                    if item.movieId == movieId{
                        //update data
                        return item
                    }
                }
                return nil
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return nil
    }
    
    ///get all custom ratings from user defaults data
    func getAllCustomRating() -> [MovieDetails]? {
        if let MovieData = defaults.object(forKey: moviekey){
            do {
                let decoder = JSONDecoder()
                // get data
                let movieArray:[MovieDetails] = try decoder.decode([MovieDetails].self, from: MovieData as! Data)
                // check videoId is already present
                return movieArray
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return nil
    }
}
