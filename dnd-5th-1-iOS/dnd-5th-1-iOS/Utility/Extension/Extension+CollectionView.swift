//
//  Extension+CollectionView.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/12.
//

import UIKit

extension UICollectionView {
    
    // CollectionViewCell
    func registerCell<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    // CollectionViewCell
    func dequeueCollectionCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell: T = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { fatalError("\(Date()): Generic UICollectionViewCell is Error") }
        
        return cell
    }
}

extension UICollectionViewCell: ReusableCell {}


