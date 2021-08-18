//
//  VoteDetailModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation

struct VoteDetailModel: Codable {
    var onePickImageId: Int?
    var isVoted: Bool?
    var votedImageId: Int?
    var title: String?
    var participantsNum: Int?
    var deadline: Date?
    var images: [VoteDetailImage]?
    
    init(onePickImageId: Int, isVoted: Bool, votedImageId: Int, title: String, participantsNum: Int, deadline: Date, images: [VoteDetailImage]) {
        self.onePickImageId = onePickImageId
        self.isVoted = isVoted
        self.votedImageId = votedImageId
        self.title = title
        self.participantsNum = participantsNum
        self.deadline = deadline
        self.images = images
    }
    
    enum CodingKeys: String, CodingKey {
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
        onePickImageId = try values.decodeIfPresent(Int.self, forKey: .onePickImageId)
        isVoted = try values.decodeIfPresent(Bool.self, forKey: .isVoted)
        votedImageId = try values.decodeIfPresent(Int.self, forKey: .votedImageId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        participantsNum = try values.decodeIfPresent(Int.self, forKey: .participantsNum)
        deadline = try values.decodeIfPresent(Date.self, forKey: .deadline)
        images = try values.decodeIfPresent([VoteDetailImage].self, forKey: .images)
    }
}

// MARK: - 투표 상세 이미지

struct VoteDetailImage: Codable {
    var imageId: String?
    var imageUrl: String?
    var pickedNum: Int?
    var emotion: Int?
    var composition: Int?
    var light: Int?
    var color: Int?
    var skip: Int?
    
    var percent: Double?
    var rank: Int?
    var sensitivityPercent: Double?
    var compositionPercent: Double?
    var lightPercent: Double?
    var colorPercent: Double?
    
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
        imageId = try values.decodeIfPresent(String.self, forKey: .imageId)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        pickedNum = try values.decodeIfPresent(Int.self, forKey: .pickedNum)
        emotion = try values.decodeIfPresent(Int.self, forKey: .emotion)
        composition = try values.decodeIfPresent(Int.self, forKey: .composition)
        light = try values.decodeIfPresent(Int.self, forKey: .light)
        color = try values.decodeIfPresent(Int.self, forKey: .color)
        skip = try values.decodeIfPresent(Int.self, forKey: .skip)
    }
}
