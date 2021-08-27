//
//  DateFormat.swift
//  Picme
//
//  Created by taeuk on 2021/08/26.
//

import Foundation

struct DateFormat {
    
    enum Format: String {
        /// "yyyy-MM-dd HH:mm:ss"
        case yyyy = "yyyy-MM-dd HH:mm:ss"
    }
    
    enum Dateformatters {
        case stringToDate
        case dateToString
    }
    
    static func convertFormat(type format: Dateformatters, formater: Format) {
        
    }
}
