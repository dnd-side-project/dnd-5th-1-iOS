//
//  VoteDetailModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation

struct VoteDetailModel: Codable {
    var isVoted: Bool?
    var votedImageId: String?
    var title: String?
    var participantsNum: Int?
    var deadline: Date?
    var images: [VoteDetailImage]?
    
    init(isVoted: Bool, votedImageId: String, title: String, participantsNum: Int, deadline: Date, images: [VoteDetailImage]) {
        self.isVoted = isVoted
        self.votedImageId = votedImageId
        self.title = title
        self.participantsNum = participantsNum
        self.deadline = deadline
        self.images = images
    }
    
    enum CodingKeys: String, CodingKey {
        case isVoted = "isVoted"
        case votedImageId = "votedImageId"
        case title = "title"
        case participantsNum = "participantsNum"
        case deadline = "expireAt"
        case images = "images"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isVoted = try values.decodeIfPresent(Bool.self, forKey: .isVoted)
        votedImageId = try values.decodeIfPresent(String.self, forKey: .votedImageId)
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
    var color: Int?
    var composition: Int?
    var light: Int?
    var skip: Int?
    
    init(imageId: String, imageUrl: String, pickedNum: Int, emotion: Int, color: Int, composition: Int, light: Int, skip: Int) {
        self.imageId = imageId
        self.imageUrl = imageUrl
        self.pickedNum = pickedNum
        self.emotion = emotion
        self.color = color
        self.composition = composition
        self.light = light
        self.skip = skip
    }
    
    enum CodingKeys: String, CodingKey {
        case imageId
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
        color = try values.decodeIfPresent(Int.self, forKey: .color)
        composition = try values.decodeIfPresent(Int.self, forKey: .composition)
        light = try values.decodeIfPresent(Int.self, forKey: .light)
        skip = try values.decodeIfPresent(Int.self, forKey: .skip)
    }
}
