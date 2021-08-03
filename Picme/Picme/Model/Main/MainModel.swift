//
//  MainModel.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

struct MainListModel: Codable {
    let mainList: [MainModel]
}

struct MainModel: Codable {
    let postId: String
    let nickname: String
    let profileimageUrl: String
    let participantsNum: Int
    let deadline: String
    let title: String
    let thumbnailUrl: [String]
}
