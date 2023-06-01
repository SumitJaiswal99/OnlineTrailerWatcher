//
//  DisplayVideosAPIModel.swift
//  SocialMediaPlayer
//
//  Created by iPHTech 29 on 14/04/23.
//

import Foundation

//MARK: - Welcome
struct VideoModel: Codable {
   let items: [Item]
}

// MARK: - Item
struct Item: Codable {
   let kind, etag: String
   let id: ID
}

// MARK: - ID
struct ID: Codable {
   let kind:String
   let videoID: String

   enum CodingKeys: String, CodingKey {
       case kind
       case videoID = "videoId"
   }
}

// MARK: - PageInfo
struct PageInfo: Codable {
   let totalResults, resultsPerPage: Int
}
