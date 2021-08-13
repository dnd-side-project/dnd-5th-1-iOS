//
//  Extension+UIFont.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit

enum NotoSans: String {
    case bold = "NotoSansCJKkr-Bold"
    case medium = "NotoSansCJKkr-Medium"
    case regular = "NotoSansCJKkr-Regular"
}

enum Montserrat: String {
    case bold = "Montserrat-Bold"
    case medium = "Montserrat-Medium"
    case semiBold = "Montserrat-SemiBold"
}

extension UIFont {
    
    static func kr(_ font: NotoSans, size: CGFloat) -> UIFont {
        switch font {
        case .bold:
            guard let font = UIFont(name: font.rawValue, size: size) else { return UIFont() }
            return font
        case .medium:
            guard let font = UIFont(name: font.rawValue, size: size) else { return UIFont() }
            return font
        case .regular:
            guard let font = UIFont(name: font.rawValue, size: size) else { return UIFont() }
            return font
        }
    }
    
    static func eng(_ font: Montserrat, size: CGFloat) -> UIFont {
        switch font {
        case .bold:
            guard let font = UIFont(name: font.rawValue, size: size) else { return UIFont() }
            return font
        case .medium:
            guard let font = UIFont(name: font.rawValue, size: size) else { return UIFont() }
            return font
        case .semiBold:
            guard let font = UIFont(name: font.rawValue, size: size) else { return UIFont() }
            return font
        }
    }
}
