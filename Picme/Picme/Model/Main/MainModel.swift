//
//  MainModel.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

struct MainModel: Codable {
    let postId: String
    let userNickname: String
    let userProfileimageUrl: String
    let participantsNum: Int
    let deadline: String
    let title: String
    let thumbnailUrl: [String]
    
    enum CodingKeys: String, CodingKey {
        case postId = "postId"
        case userNickname = "username"
        case userProfileimageUrl = "userProfileImage"
        case participantsNum = "participantsNum"
        case deadline = "expireAt"
        case title = "title"
        case thumbnailUrl = "thumbnailUrl"
    }
}
