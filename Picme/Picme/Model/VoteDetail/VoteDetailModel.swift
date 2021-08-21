//
//  VoteDetailModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation

struct VoteDetailModel: Codable {
    var postNickname: String
    var postProfileUrl: String
    var onePickImageId: Int
    var isVoted: Bool
    var votedImageId: Int
    var title: String
    var participantsNum: Int
    var deadline: String
    var images: [VoteDetailImage]
    
    enum CodingKeys: String, CodingKey {
        case postNickname = "nickname"
        case postProfileUrl = "userProfileUrl"
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
    var imageId: String
    var imageUrl: String
    var pickedNum: Int
    var emotion: Int
    var composition: Int
    var light: Int
    var color: Int
    var skip: Int
    
    enum CodingKeys: String, CodingKey {
        case imageId = "id"
        case imageUrl
        case pickedNum
        case emotion
        case color
        case composition
        case light
        case skip
    }
}

struct VoteResultModel {
        var percent: Double
        var rank: Int
        var sensitivityPercent: Double
        var compositionPercent: Double
        var lightPercent: Double
        var colorPercent: Double
    
    init(percent: Double, rank: Int, sensitivityPercent: Double, compositionPercent: Double, lightPercent: Double, colorPercent: Double) {
        self.percent = percent
        self.rank = rank
        self.sensitivityPercent = sensitivityPercent
        self.compositionPercent = compositionPercent
        self.lightPercent = lightPercent
        self.colorPercent = colorPercent
    }
}
