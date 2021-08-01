//
//  Extension+UIColor.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/11.
//

import UIKit

// Enum 이름 수정 예정
enum SolidColor {
    case solid0
    case solid12
    case solid16
    case solid26
    case solid32
}

enum TextColor {
    case text32
    case text50
    case text71
    case text91
    case text100
}

enum LogoColor {
    case logoPink
}

enum MainColor {
    case pink
    case orange
    case mint
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
    
    static func logoColor(_ color: LogoColor) -> UIColor {
        switch color {
        case .logoPink:
            return UIColor(red: 242/255, green: 28/255, blue: 160/255, alpha: 1.0)
        }
    }
    
    static func mainColor(_ color: MainColor) -> UIColor {
        switch color {
        case .pink:
            return UIColor(red: 235/255, green: 73/255, blue: 154/255, alpha: 1.0)
        case .orange:
            return UIColor(red: 240/255, green: 121/255, blue: 60/255, alpha: 1.0)
        case .mint:
            return UIColor(red: 51/255, green: 204/255, blue: 140/255, alpha: 1.0)
        }
    }
}
