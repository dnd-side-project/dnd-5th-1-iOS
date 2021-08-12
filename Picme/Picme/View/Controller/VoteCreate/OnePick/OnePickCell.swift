//
//  OnePickCell.swift
//  Picme
//
//  Created by taeuk on 2021/08/09.
//

import UIKit

class OnePickCell: UICollectionViewCell {
    
    let cellImages: UIImageView = {
        $0.contentMode = .scaleToFill
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfiguration()
        cellImages.clipsToBounds = true
        cellImages.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("Image Upload Cell init?")
    }
    
    func showUserImage(_ image: UIImage) {
        cellImages.image = image
    }
    
    func setConfiguration() {
        
        self.addSubview(cellImages)
        cellImages.translatesAutoresizingMaskIntoConstraints = false
        cellImages.topAnchor.constraint(equalTo: contentView.topAnchor)
            .isActive = true
        cellImages.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        cellImages.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        cellImages.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        
    }
}
