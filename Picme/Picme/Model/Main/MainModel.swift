//
//  MainModel.swift
//  Picme
//
//  Created by 권민하 on 2021/07/30.
//

import Foundation

struct MainModel: Codable {
    let postId: String
    let deadline: String?
    let title: String
    let user: User
    let images: [Images]?
    let participantsNum: Int
    
    enum CodingKeys: String, CodingKey {
        case postId = "id"
        case user = "user"
        case participantsNum = "participantsNum"
        case deadline = "expiredAt"
        case title = "title"
        case images = "images"
    }
}

struct User: Codable {
    let nickname: String
    let profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nickname"
        case profileImageUrl = "imageUrl"
    }
}

struct Images: Codable {
    let thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbnailUrl = "thumbnailUrl"
    }
}
