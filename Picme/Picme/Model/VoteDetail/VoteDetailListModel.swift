//
//  VoteDetailListModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/11.
//

import Foundation

struct VoteDetailListModel: Codable {
    var detailList: [VoteDetailModel]?
    
    init(detailList: [VoteDetailModel]){
        self.detailList = detailList
    }
    
    enum CodingKeys: String, CodingKey {
        case detailList
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        detailList = try values.decodeIfPresent([VoteDetailModel].self, forKey: .detailList)
    }
}
