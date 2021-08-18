//
//  VoteDetailCollectionViewCell.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import UIKit
import ScalingCarousel

class VoteDetailCollectionViewCell: ScalingCarouselCell {
    @IBOutlet weak var detailPhotoImageView: UIImageView!
    @IBOutlet weak var resultColorView: UIView!
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var diamondsImageView: UIImageView!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var pickedNumLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
}
