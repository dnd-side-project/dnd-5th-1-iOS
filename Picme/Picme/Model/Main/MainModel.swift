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
    let nickname: String
    let profileimageUrl: String
    let date: String
    let deadline: String
    let title: String
    let description: String
    let images: [String]
}
