//
//  MainListModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/11.
//

import Foundation

struct MainListModel: Codable {
    let mainList: [MainModel]
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case mainList = "posts"
        case total = "total"
    }
}
