//
//  MyCollectionViewCell.swift
//  SocialMediaPlayer
//
//  Created by iPHTech 29 on 07/04/23.
//

import UIKit
import Cosmos

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
 
    
    @IBOutlet weak var showStarRating: CosmosView!
    @IBOutlet weak var showselfratingLabel: UILabel!
    
    @IBOutlet weak var titlesPosterUIImageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    

    //weak var delegate:MyCollectionViewCellDelegate?
}
