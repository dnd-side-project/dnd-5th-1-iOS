//
//  Extension+UIFont.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit

enum NotoSans: String {
    /// Weight 700
    case bold = "NotoSansCJKkr-Bold"
    /// Weight 500
    case medium = "NotoSansCJKkr-Medium"
    /// Weight 400
    case regular = "NotoSansCJKkr-Regular"
}

enum Montserrat: String {
    /// Weight 700
    case bold = "Montserrat-Bold"
    /// Weight 600
    case medium = "Montserrat-Medium"
    /// Weight 500
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
