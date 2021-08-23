//
//  VoteDetailModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation

// MARK: - 투표 상세 데이터

struct VoteDetailModel: Codable {
    var postNickname: String
    var postProfileUrl: String
    var onePickImageId: Int
    var isVoted: Bool
    var votedImageId: Int
    var title: String
    var participantsNum: Int
    var deadline: String?
    var images: [VoteDetailImage]
    
    init(postNickname: String, postProfileUrl: String, onePickImageId: Int, isVoted: Bool, votedImageId: Int, title: String, participantsNum: Int, deadline: String, images: [VoteDetailImage]) {
        self.postNickname = postNickname
        self.postProfileUrl = postProfileUrl
        self.onePickImageId = onePickImageId
        self.isVoted = isVoted
        self.votedImageId = votedImageId
        self.title = title
        self.participantsNum = participantsNum
        self.deadline = deadline
        self.images = images
    }
    
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postNickname = try values.decodeIfPresent(String.self, forKey: .postNickname) ?? ""
        postProfileUrl = try values.decodeIfPresent(String.self, forKey: .postProfileUrl) ?? ""
        onePickImageId = try values.decodeIfPresent(Int.self, forKey: .onePickImageId) ?? 0
        isVoted = try values.decodeIfPresent(Bool.self, forKey: .isVoted) ?? false
        votedImageId = try values.decodeIfPresent(Int.self, forKey: .votedImageId) ?? 0
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        participantsNum = try values.decodeIfPresent(Int.self, forKey: .participantsNum) ?? 0
        deadline = try values.decodeIfPresent(String.self, forKey: .deadline)
        images = try values.decodeIfPresent([VoteDetailImage].self, forKey: .images) ?? []
    }
    
}

// MARK: - 투표 이미지

struct VoteDetailImage: Codable {
    var imageId: String
    var imageUrl: String
    var pickedNum: Int
    var emotion: Int
    var composition: Int
    var light: Int
    var color: Int
    var skip: Int
    
    init(imageId: String, imageUrl: String, pickedNum: Int, emotion: Int, composition: Int, light: Int, color: Int, skip: Int) {
        self.imageId = imageId
        self.imageUrl = imageUrl
        self.pickedNum = pickedNum
        self.emotion = emotion
        self.composition = composition
        self.light = light
        self.color = color
        self.skip = skip
        
    }
    
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        imageId = try values.decodeIfPresent(String.self, forKey: .imageId) ?? ""
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
        pickedNum = try values.decodeIfPresent(Int.self, forKey: .pickedNum) ?? 0
        emotion = try values.decodeIfPresent(Int.self, forKey: .emotion) ?? 0
        composition = try values.decodeIfPresent(Int.self, forKey: .composition) ?? 0
        light = try values.decodeIfPresent(Int.self, forKey: .light) ?? 0
        color = try values.decodeIfPresent(Int.self, forKey: .color) ?? 0
        skip = try values.decodeIfPresent(Int.self, forKey: .skip) ?? 0
    }
}

// MARK: - 투표 이미지 결과 데이터

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
