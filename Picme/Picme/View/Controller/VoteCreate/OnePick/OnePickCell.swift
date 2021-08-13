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
    }
}
