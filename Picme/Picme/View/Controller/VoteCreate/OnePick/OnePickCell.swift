//
//  OnePickCell.swift
//  Picme
//
//  Created by taeuk on 2021/08/09.
//

import UIKit
import SnapKit

class OnePickCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let cellImages: UIImageView = {
        $0.contentMode = .scaleToFill
        return $0
    }(UIImageView())
    
    let pickImage: UIImageView = {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "notonepick")
        return $0
    }(UIImageView())
    
    let pickLayer: UIView = {
        $0.backgroundColor = .clear
        return $0
    }(UIView())
    
    let pickCenterImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
        $0.isHidden = true
        $0.image = UIImage(named: "diamonds")
        return $0
    }(UIImageView())
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfiguration()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        cellImages.clipsToBounds = true
        cellImages.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("Image Upload Cell init?")
    }
    
    // MARK: - Method
    
    func showUserImage(_ image: UIImage) {
        cellImages.image = image
    }
    
    func setConfiguration() {
        
        self.addSubview(cellImages)
        cellImages.addSubview(pickLayer)
        cellImages.addSubview(pickImage)
        pickLayer.addSubview(pickCenterImage)
        
        cellImages.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        pickLayer.snp.makeConstraints {
            $0.edges.equalTo(cellImages)
        }
        
        pickImage.snp.makeConstraints {
            $0.top.equalTo(cellImages).offset(10)
            $0.trailing.equalTo(cellImages).offset(-10)
            $0.width.equalTo(pickImage.snp.height).multipliedBy(1/1)
        }
        
        pickCenterImage.snp.makeConstraints {
            $0.centerX.equalTo(pickLayer.snp.centerX)
            $0.centerY.equalTo(pickLayer.snp.centerY)
            $0.width.equalTo(pickCenterImage.snp.height).multipliedBy(1/1)
        }
    }
}
