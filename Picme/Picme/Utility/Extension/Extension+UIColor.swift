//
//  Extension+UIColor.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit

// Enum, case 이름 수정 예정
enum SolidColor {
    /// #000000, RGB(0, 0, 0, alpha: 1.0)
    case solid0
    /// #1A1C1F, RGB(26, 28, 31, alpha: 1.0)
    case solid12
    /// #212428, RGB(33, 36, 40, alpha: 1.0)
    case solid16
    /// #373C42, RGB(55, 60, 66, alpha: 1.0)
    case solid26
    /// #494D52, RGB(73, 77, 82, alpha: 1.0)
    case solid32
}

enum TextColor {
    /// #4D4F52, RGB(77, 79, 82, alpha: 1.0)
    case text32
    /// #787B80, RGB(120, 123, 128, alpha: 1.0)
    case text50
    /// #B2B4B6, RGB(178, 180, 182, alpha: 1.0)
    case text71
    /// #E6E7E9, RGB(230, 231, 233, alpha: 1.0)
    case text91
    /// #FEFEFE, RGB(254, 254, 254, alpha: 1.0)
    case text100
}

enum MainColor {
    /// #F21CA0, RGB(242, 28, 160, alpha: 1.0)
    case logoPink
    /// #EB499A, RGB(235, 73, 154, alpha: 1.0)
    case pink
    /// #F0793C, RGB(240, 121, 60, alpha: 1.0)
    case orange
    /// #33CC8C, RGB(51, 204, 140, alpha: 1.0)
    case mint
    /// #EB499A, RGB(235, 73, 154, alpha: 0.8)
    case pink80
    /// #F0793C, RGB(240, 121, 60, alpha: 0.8)
    case orange80
    /// #33CC8C, RGB(51, 204, 140, alpha: 0.8)
    case mint80
    
}

extension UIColor {
    
    static func solidColor(_ color: SolidColor) -> UIColor {
        switch color {
        case .solid0:
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        case .solid12:
            return UIColor(red: 26/255, green: 28/255, blue: 31/255, alpha: 1.0)
        case .solid16:
            return UIColor(red: 33/255, green: 36/255, blue: 40/255, alpha: 1.0)
        case .solid26:
            return UIColor(red: 55/255, green: 60/255, blue: 66/255, alpha: 1.0)
        case .solid32:
            return UIColor(red: 73/255, green: 77/255, blue: 82/255, alpha: 1.0)
        }
    }
    
    static func textColor(_ color: TextColor) -> UIColor {
        switch color {
        case .text32:
            return UIColor(red: 77/255, green: 79/255, blue: 82/255, alpha: 1.0)
        case .text50:
            return UIColor(red: 120/255, green: 123/255, blue: 128/255, alpha: 1.0)
        case .text71:
            return UIColor(red: 178/255, green: 180/255, blue: 182/255, alpha: 1.0)
        case .text91:
            return UIColor(red: 230/255, green: 231/255, blue: 233/255, alpha: 1.0)
        case .text100:
            return UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1.0)
        }
    }
    
    static func mainColor(_ color: MainColor) -> UIColor {
        switch color {
        case .logoPink:
            return UIColor(red: 242/255, green: 28/255, blue: 160/255, alpha: 1.0)
        case .pink:
            return UIColor(red: 235/255, green: 73/255, blue: 154/255, alpha: 1.0)
        case .orange:
            return UIColor(red: 240/255, green: 121/255, blue: 60/255, alpha: 1.0)
        case .mint:
            return UIColor(red: 51/255, green: 204/255, blue: 140/255, alpha: 1.0)
        case .pink80:
            return UIColor(red: 235/255, green: 73/255, blue: 154/255, alpha: 0.8)
        case .orange80:
            return UIColor(red: 240/255, green: 121/255, blue: 60/255, alpha: 0.8)
        case .mint80:
            return UIColor(red: 51/255, green: 204/255, blue: 140/255, alpha: 0.8)
        }
    }
}
