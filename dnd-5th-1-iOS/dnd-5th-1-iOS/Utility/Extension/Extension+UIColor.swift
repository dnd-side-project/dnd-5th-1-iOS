//
//  Extension+UIColor.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit

enum MainColor {
    case sampleColor
}

extension UIColor {
    
    static func appMainColor(_ color: MainColor) -> UIColor {
        switch color {
        case .sampleColor:
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            
        @unknown default:
            return UIColor()
        }
    }
}
