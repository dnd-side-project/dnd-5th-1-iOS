//
//  CreateListModel.swift
//  Picme
//
//  Created by taeuk on 2021/08/16.
//

import Foundation

struct CreateListModel: Codable {
    let title: String
    let expiredAt: String
}

struct CreateListReponseModel: Codable {
    let postId: String
}
