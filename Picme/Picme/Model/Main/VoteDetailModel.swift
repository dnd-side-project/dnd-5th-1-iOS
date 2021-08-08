//
//  VoteDetailModel.swift
//  Picme
//
//  Created by 권민하 on 2021/08/07.
//

import Foundation

struct VoteDetailListModel: Codable {
    var detailList : [VoteDetailModel]?
    
    init(detailList : [VoteDetailModel]){
        self.detailList = detailList
    }
}

struct VoteDetailModel: Codable {
    var nickname: String?
    var profileImage: String?
    var deadline: String?
    var isVoted: Bool?
    var votedImageId: String?
    var title: String?
    var description: String?
    var participantsNum: Int?
    var images: [VoteDetailImage]?
    
    init(nickname: String,
         profileImage: String,
         deadline: String,
         isVoted: Bool,
         votedImageId: String,
         title: String,
         description: String,
         participantsNum: Int,
         images: [VoteDetailImage]) {
        
        self.nickname = nickname
        self.profileImage = profileImage
        self.deadline = deadline
        self.isVoted = isVoted
        self.votedImageId = votedImageId
        self.title = title
        self.description = description
        self.participantsNum = participantsNum
        self.images = images
    }
}

struct VoteDetailImage: Codable {
    var imageId: String?
    var imageUrl: String?
    var pickedNum: Int?
    /*
    var 감성: Int?
    var 감성: Int?
    var 감성: Int?
    var 감성: Int?
    */
}
