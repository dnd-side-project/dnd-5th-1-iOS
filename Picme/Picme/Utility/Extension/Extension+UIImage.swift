//
//  Extension+UIImage.swift
//  Picme
//
//  Created by 권민하 on 2021/09/03.
//

import UIKit

enum ProfileImage {
    case imagePink
    case imageOrange
    case imageGreen
}

extension UIImage {
    
    static func profileImage(_ image: ProfileImage) -> UIImage {
        switch image {
        case .imagePink:
            return #imageLiteral(resourceName: "profilePink")
        case .imageOrange:
            return #imageLiteral(resourceName: "profileOrange")
        case .imageGreen:
            return #imageLiteral(resourceName: "profileGreen")
        }
    }
    
}
