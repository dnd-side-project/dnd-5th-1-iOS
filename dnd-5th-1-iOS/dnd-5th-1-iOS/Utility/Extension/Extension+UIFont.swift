//
//  Extension+UIFont.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit

enum MainFont:String {
    case sampleFont = "HelveticaNeue-Bold"
}

extension UIColor {
    
    static func appMainFont(_ font: MainFont) -> UIFont {
        switch font {
        case .sampleFont:
            guard let font = UIFont(name: font.rawValue, size: 18) else { return UIFont() }
            return font
        }
    }
}
