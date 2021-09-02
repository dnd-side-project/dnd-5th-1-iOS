//
//  Extension+UIImage.swift
//  Picme
//
//  Created by 권민하 on 2021/09/03.
//

import UIKit

extension UIImage {
    
    static func profileImage(_ index: String) -> UIImage {
        switch index {
        case "1":
            return #imageLiteral(resourceName: "profilePink")
        case "2":
            return #imageLiteral(resourceName: "profileOrange")
        case "3":
            return #imageLiteral(resourceName: "profileGreen")
        default:
            return #imageLiteral(resourceName: "profilePink")
        }
    }
    
}
