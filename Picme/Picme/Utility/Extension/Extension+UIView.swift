//
//  Extension+UIView.swift
//  Picme
//
//  Created by 권민하 on 2021/08/15.
//

import UIKit

extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadiusLayer: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
    }
    
    // MARK: - View 원형으로 만들기
    
    func circular() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.contentMode = UIView.ContentMode.scaleAspectFit
    }
}
