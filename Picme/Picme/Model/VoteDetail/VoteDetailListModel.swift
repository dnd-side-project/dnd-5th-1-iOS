//
//  VoteDetailListModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/11.
//

import Foundation

struct VoteDetailListModel: Codable {
    let detailList: [VoteDetailModel]
    
    enum CodingKeys: String, CodingKey {
        case detailList
    }
}
