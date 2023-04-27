//
//  AddPercent.swift
//  SocialMediaPlayer
//
//  Created by iPHTech 29 on 27/04/23.
//

import Foundation

extension  String {
    func addpercent() -> String{
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
