//
//  MainListModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/11.
//

import Foundation

struct MainListModel: Codable {
    let mainList: [MainModel]
    
//    init(mainList : [MainModel]){
//        self.mainList = mainList
//    }
    
    enum CodingKeys: String, CodingKey {
        case mainList = "posts"
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        mainList = try values.decodeIfPresent([MainModel].self, forKey: .mainList)
//    }
}
