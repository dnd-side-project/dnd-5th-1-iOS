//
//  MyPageModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/28.
//

import Foundation

struct MyPageModel: Codable {
    let createdCount: Int
    let attendedCount: Int
    
    enum CodingKeys: String, CodingKey {
        case createdCount = "numOfCreatedPosts"
        case attendedCount = "numOfAttendedPosts"
        
    }
}
