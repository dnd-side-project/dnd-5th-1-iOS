//
//  VoteDetailModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation

struct VoteDetailModel: Codable {
    let onePickImageId: Int
    let isVoted: Bool
    let votedImageId: Int
    let title: String
    let participantsNum: Int
    let deadline: Date?
    var images: [VoteDetailImage]
    
    enum CodingKeys: String, CodingKey {
        case onePickImageId = "firstPickIndex"
        case isVoted = "isVoted"
        case votedImageId = "votedImageIndex"
        case title = "title"
        case participantsNum = "participantsNum"
        case deadline = "expiredAt"
        case images = "images"
    }
}

// MARK: - 투표 상세 이미지

struct VoteDetailImage: Codable {
    let imageId: String
    let imageUrl: String
    let pickedNum: Int
    let emotion: Int
    let composition: Int
    let light: Int
    let color: Int
    let skip: Int
    
    var percent: Double
    var rank: Int
    var sensitivityPercent: Double
    var compositionPercent: Double
    var lightPercent: Double
    var colorPercent: Double
    
    enum CodingKeys: String, CodingKey {
        case imageId = "id"
        case imageUrl
        case pickedNum
        case emotion
        case color
        case composition
        case light
        case skip
        
        case percent
        case rank
        case sensitivityPercent
        case compositionPercent
        case lightPercent
        case colorPercent
        
    }
}
