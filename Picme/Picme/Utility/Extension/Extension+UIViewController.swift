//
//  Extension+UIViewController.swift
//  Picme
//
//  Created by 권민하 on 2021/08/18.
//

import UIKit

extension UIViewController {
    
    func gsno(_ data: String?) -> String {
        guard let str = data else {
            return ""
        }
        return str
    }
    
    func gino(_ data: Int?) -> Int {
        guard let num = data else {
            return 0
        }
        return num
    }
    
    func gdno(_ data: Double?) -> Double {
        guard let num = data else {
            return 0
        }
        return num
    }
}
